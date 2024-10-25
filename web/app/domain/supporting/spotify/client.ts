import { tracked } from '@glimmer/tracking';

import { useMachine } from 'ember-statecharts';
import SpotifyWebApi from 'spotify-web-api-js';
import SpotifyPlayer from 'spotify-web-playback';

import { SpotifyMachine } from './machine';

import type { Track } from './domain-objects';

export class SpotifyClient {
  @tracked error?: string;
  @tracked track?: Track;

  api = new SpotifyWebApi();
  player = new SpotifyPlayer('UniDancing');

  private deviceId?: string = undefined;

  statechart = useMachine(this, () => {
    const { connectPlayer, loadPlayback } = this;

    return {
      machine: SpotifyMachine.withConfig({
        services: {
          connectPlayer: async (_, { accessToken }) => {
            await connectPlayer(accessToken as string);
          },
          loadPlayback
        }
      }),
      interpreterOptions: {
        devTools: true
      }
    };
  });

  loadPlayback = () => async () => {
    const playing = await this.player.getPlaybackState();

    if (playing?.item) {
      this.track = playing.item as unknown as Track;
    }

    if (playing?.is_playing) {
      this.statechart.send('play');
    }
  };

  connectPlayer = async (accessToken: string) => {
    this.player.addListener('error', (e) => {
      console.warn(e);
    });

    this.player.addListener('state', (state) => {
      if (!state) return;

      if (state.paused) {
        this.statechart.send('pause');
      } else {
        this.statechart.send('play');

        this.track = state.track_window.current_track as unknown as Track;
      }
    });

    await this.player.connect(accessToken);

    if (!this.player.ready) {
      throw new Error();
    } else {
      // eslint-disable-next-line @typescript-eslint/ban-ts-comment
      // @ts-ignore
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
      this.deviceId = this.player._deviceId;
    }
  };

  // exported states

  get authenticated() {
    return this.statechart.state?.matches('authenticated');
  }

  get playing() {
    return this.statechart.state?.matches({
      authenticated: {
        playback: 'playing'
      }
    });
  }

  get ready() {
    return (
      this.statechart.state?.matches({
        authenticated: 'ready'
      }) ||
      this.statechart.state?.matches({
        authenticated: 'playback'
      })
    );
  }

  // methods

  authenticate = async (accessToken: string) => {
    try {
      this.api.setAccessToken(accessToken);

      await this.api.getMe();

      this.statechart.send('authenticate', { accessToken });

      return true;
    } catch {
      this.api.setAccessToken(null);

      return false;
    }
  };

  play = async (options?: SpotifyApi.PlayParameterObject) => {
    await this.api.play({
      // eslint-disable-next-line @typescript-eslint/naming-convention
      device_id: this.deviceId,
      ...options
    });
  };

  pause = async () => {
    // await this.api.pause();
    await this.player.pause();
  };

  toggle = () => {
    if (this.playing) {
      void this.pause();
    } else {
      void this.play();
    }
  };

  setVolume = async (volumePercent: number) => {
    try {
      await this.player.setVolume(volumePercent);
    } catch {
      // not empty
    }
  };
}
