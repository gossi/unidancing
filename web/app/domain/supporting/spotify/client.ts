import { tracked } from '@glimmer/tracking';

import { dropTask } from 'ember-concurrency';
import { useMachine } from 'ember-statecharts';
import SpotifyWebApi from 'spotify-web-api-js';
import SpotifyPlayer from 'spotify-web-playback';

import { SpotifyMachine } from './machine';

import type { Device, Track } from './domain-objects';

export class SpotifyClient {
  @tracked devices: Device[] = [];
  @tracked device?: Device;
  @tracked error?: string;
  @tracked track?: Track;

  api = new SpotifyWebApi();
  player = new SpotifyPlayer('UniDancing');

  // private deviceId?: string = undefined;

  statechart = useMachine(this, () => {
    const { loadDevices, autoselectDevice, connectPlayer, loadPlayback, hasDevices } = this;

    return {
      machine: SpotifyMachine.withConfig({
        guards: {
          hasDevices
        },
        services: {
          connectPlayer: async (_, { accessToken }) => {
            await connectPlayer(accessToken as string);
          },
          loadDevices: () => loadDevices.perform(),
          autoselectDevice,
          loadPlayback
        }
      }),
      interpreterOptions: {
        devTools: true
      }
    };
  });

  // AUTH

  get authenticated() {
    return this.statechart.state?.matches('authenticated');
  }

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

  // DEVICES

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

  hasDevices = () => {
    return this.player.ready || this.devices.length > 0;
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
    }
  };

  loadDevices = dropTask(async () => {
    this.devices = (await this.api.getMyDevices()).devices;
  });

  autoselectDevice = async () => {
    if (this.player.ready) {
      // eslint-disable-next-line @typescript-eslint/ban-ts-comment
      // @ts-ignore
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
      await this.selectDevice({
        // eslint-disable-next-line @typescript-eslint/ban-ts-comment
        // @ts-ignore
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
        id: this.player._deviceId,
        // eslint-disable-next-line @typescript-eslint/ban-ts-comment
        // @ts-ignore
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
        name: this.player._name,
        type: 'Computer'
      });
    }

    const device =
      // at first try to find the active device
      (this.devices.find((dev) => dev.is_active) ??
      // if not found, see if there is only one, then pick that one
      this.devices.length === 1)
        ? this.devices[0]
        : undefined;

    if (device) {
      await this.selectDevice(device);
    }
  };

  selectDevice = async (device: Device) => {
    try {
      await this.api.transferMyPlayback([device.id as string]);
      this.device = device;
      this.statechart.send('selectDevice');
      // eslint-disable-next-line no-empty
    } catch {}
  };

  // PLAYBACK

  get playing() {
    return this.statechart.state?.matches({
      authenticated: {
        playback: 'playing'
      }
    });
  }

  loadPlayback = () => async () => {
    const playing = await this.player.getPlaybackState();

    if (playing?.item) {
      this.track = playing.item as unknown as Track;
    }

    if (playing?.is_playing) {
      this.statechart.send('play');
    }
  };

  play = async (options?: SpotifyApi.PlayParameterObject) => {
    await this.api.play({
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

  // MISC

  setVolume = async (volumePercent: number) => {
    try {
      await this.api.setVolume(volumePercent);
    } catch {
      // not empty
    }
  };
}
