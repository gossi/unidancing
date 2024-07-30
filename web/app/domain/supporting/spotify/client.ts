import { tracked } from '@glimmer/tracking';

import { dropTask } from 'ember-concurrency';
import { Resource } from 'ember-resources';
import { useMachine } from 'ember-statecharts';
import SpotifyWebApi from 'spotify-web-api-js';

import { SpotifyEvent, SpotifyMachine, SpotifyState } from './machine';
import { TrackResource } from './resources/track';

import type { Device, Track } from './domain-objects';

export class SpotifyClient extends Resource {
  @tracked devices: Device[] = [];
  @tracked device?: Device;
  @tracked track?: TrackResource;

  statechart = useMachine(this, () => {
    const { loadDevices, autoselectDevice, loadPlayback } = this;

    return {
      machine: SpotifyMachine.withConfig({
        guards: {
          hasDevice: () => {
            return this.devices.length > 0;
          }
        },
        services: {
          loadDevices: () => loadDevices.perform(),
          autoselectDevice,
          loadPlayback
        }
      })
    };
  });

  api = new SpotifyWebApi();

  // machine services
  loadDevices = dropTask(async () => {
    this.devices = (await this.api.getMyDevices()).devices;
  });

  autoselectDevice = async () => {
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

  loadPlayback = () => async () => {
    const playing = await this.api.getMyCurrentPlayingTrack();

    if (playing.item) {
      this.track = TrackResource.from(this, () => ({
        track: playing.item
      }));
    }

    if (playing.is_playing) {
      this.statechart.send(SpotifyEvent.Play);
    }
  };

  // exported states

  get authenticated() {
    return this.statechart.state?.matches(SpotifyState.Authenticated);
  }

  get playing() {
    return this.statechart.state?.matches({
      [SpotifyState.Authenticated]: {
        [SpotifyState.Playback]: SpotifyState.Playing
      }
    });
  }

  get ready() {
    return this.statechart.state?.matches({
      [SpotifyState.Authenticated]: {
        [SpotifyState.Device]: SpotifyState.Ready
      }
    });
  }

  // methods

  authenticate = async (accessToken: string) => {
    try {
      this.api.setAccessToken(accessToken);

      await this.api.getMe();

      this.statechart.send(SpotifyEvent.Authenticate);

      return true;
    } catch (e) {
      this.api.setAccessToken(null);

      return false;
    }
  };

  play = async (options?: SpotifyApi.PlayParameterObject) => {
    await this.api.play(options);
    this.statechart.send(SpotifyEvent.Play);
  };

  pause = async () => {
    await this.api.pause();
    this.statechart.send(SpotifyEvent.Pause);
  };

  toggle = () => {
    if (this.playing) {
      void this.pause();
    } else {
      void this.play();
    }
  };

  selectDevice = async (device: Device) => {
    try {
      await this.api.transferMyPlayback([device.id as string]);
      this.device = device;
      this.statechart.send(SpotifyEvent.SelectDevice);
      // eslint-disable-next-line no-empty
    } catch {}
  };

  setVolume = async (volumePercent: number) => {
    try {
      await this.api.setVolume(volumePercent);
    } catch {
      // not empty
    }
  };

  selectTrack = (track: Track) => {
    this.track = TrackResource.from(this, () => ({ track }));
  };
}
