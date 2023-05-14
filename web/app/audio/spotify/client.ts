import { tracked } from '@glimmer/tracking';

import { Resource } from 'ember-resources';
import { useMachine } from 'ember-statecharts';
import SpotifyWebApi from 'spotify-web-api-js';

import { SpotifyEventNames, SpotifyMachine, SpotifyStateNames } from './machine';
import { useTrack } from './resources/track';

import type { SpotifyContext, SpotifyEvent, SpotifyState } from './machine';
import type { SpotifyTrackResource } from './resources/track';

import { action} from '@ember/object';

export class SpotifyClient extends Resource {
  @tracked devices: SpotifyApi.UserDevice[] = [];
  @tracked device?: SpotifyApi.UserDevice;
  @tracked track?: SpotifyTrackResource;

  statechart = useMachine<SpotifyContext, any, SpotifyEvent, SpotifyState>(this, () => {
    return {
      machine: SpotifyMachine.withConfig({
        guards: {
          hasDevice: () => {
            return this.devices.length > 0;
          }
        },
        services: {
          loadDevices: async () => {
            this.devices = (await this.api.getMyDevices()).devices;
            console.log('loadDevices', this.devices);

          },
          autoselectDevice: async () => {
            this.device = this.devices.find((device) => device.is_active);

            if (!this.device && this.devices.length === 1) {
              const device = this.devices[0];

              await this.api.transferMyPlayback([device.id as string]);
              this.device = device;
            }
          },
          loadPlayback: () => async (send) => {
            const playing = await this.api.getMyCurrentPlayingTrack();

            if (playing?.item) {
              this.track = useTrack(this, { track: playing.item });
            }

            if (playing.is_playing) {
              send(SpotifyEventNames.Play);
            }
          }
        }
      })
    };
  });

  api = new SpotifyWebApi();

  // exported states

  get authenticated() {
    return this.statechart.state?.matches(SpotifyStateNames.Authenticated);
  }

  get playing() {
    console.log('playing?', this.statechart.state?.matches({
      [SpotifyStateNames.Authenticated]: {
        [SpotifyStateNames.Playback]: SpotifyStateNames.Playing
      }
    }));

    return this.statechart.state?.matches({
      [SpotifyStateNames.Authenticated]: {
        [SpotifyStateNames.Playback]: SpotifyStateNames.Playing
      }
    });
  }

  get ready() {
    return this.statechart.state?.matches({
      [SpotifyStateNames.Authenticated]: {
        [SpotifyStateNames.Device]: SpotifyStateNames.Ready
      }
    });
  }

  // methods

  authenticate = async (accessToken: string) => {
    try {
      this.api.setAccessToken(accessToken);
      const me = await this.api.getMe();
      console.log('me', me);

      this.statechart.send(SpotifyEventNames.Authenticate);

      return true;
    } catch (e) {
      this.api.setAccessToken(null);

      return false;
    }
  };

  play = async (options?: SpotifyApi.PlayParameterObject) => {
    await this.api.play(options);
    this.statechart.send(SpotifyEventNames.Play);
  };

  pause = async () => {
    await this.api.pause();
    this.statechart.send(SpotifyEventNames.Pause);
  };

  toggle = () => {
    if (this.playing) {
      this.pause();
    } else {
      this.play();
    }
  }

  selectDevice = async (device: SpotifyApi.UserDevice) => {
    try {
      await this.api.transferMyPlayback([device.id as string]);
      this.device = device;
      this.statechart.send(SpotifyEventNames.SelectDevice);
      // eslint-disable-next-line no-empty
    } catch {}
  };

  @action
  selectTrack(track: SpotifyApi.TrackObjectFull) {
    const resource = useTrack(this, { track });
    this.track = resource;
    console.log('SpotifyClient.selectTrack', this.track, resource, track);
  }
}
