import { action } from '@ember/object';
import { service, Registry as Services } from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { Player } from '../player';
import { SpotifyTrackResource } from './resources/track';
import { useTrack } from './resources/track';
import { useMachine, matchesState } from 'ember-statecharts';
import { SpotifyMachine, SpotifyEvent, SpotifyState } from './machine';

export default class SpotifyPlayer implements Player {
  @service declare spotify: Services['spotify'];

  statechart = useMachine(this, () => {
    const { autoSelectDevice } = this;
    return {
      machine: SpotifyMachine.withContext({ autoSelectDevice }).withConfig({
        actions: {
          autoselect({ autoSelectDevice }) {
            autoSelectDevice();
          }
        }
      })
    };
  });

  private static instance?: SpotifyPlayer;

  private constructor() {
    // ...
  }

  static getInstance(): SpotifyPlayer {
    if (!SpotifyPlayer.instance) {
      SpotifyPlayer.instance = new SpotifyPlayer();
    }

    return SpotifyPlayer.instance;
  }

  @tracked devices: SpotifyApi.UserDevice[] = [];
  @tracked track?: SpotifyTrackResource;
  @tracked device?: SpotifyApi.UserDevice;

  @matchesState({
    [SpotifyState.Authenticated]: {
      [SpotifyState.Playback]: SpotifyState.Playing
    }
  })
  declare playing: boolean;

  @matchesState({
    [SpotifyState.Authenticated]: {
      [SpotifyState.Device]: SpotifyState.Ready
    }
  })
  declare ready: boolean;

  get client() {
    return this.spotify.client;
  }

  async loadDevices() {
    this.devices = (await this.spotify.client.getMyDevices()).devices;
    this.device = this.devices.find((device) => device.is_active);
    this.statechart.send(SpotifyEvent.DevicesLoaded);
  }

  async loadPlayback() {
    const playing = await this.spotify.client.getMyCurrentPlayingTrack();
    if (playing?.item) {
      this.track = useTrack(this, { track: playing.item });
    }

    if (playing.is_playing) {
      this.statechart.send(SpotifyEvent.Play);
    }
  }

  // async load() {
  //   await Promise.all([this.loadDevices, this.loadPlayback]);
  // }

  /**
   * Try to automatically select a device, when:
   *
   * 1. There is currently no active device
   * 2. There is only one device to choose from
   */
  async autoSelectDevice() {
    // try selecting a device
    if (!this.device && this.devices.length === 1) {
      await this.selectDevice(this.devices[0]);
    }
  }

  @action
  async selectDevice(device: SpotifyApi.UserDevice) {
    try {
      await this.client.transferMyPlayback([device.id as string]);
      this.device = device;
      this.statechart.send(SpotifyEvent.SelectDevice);
      // eslint-disable-next-line no-empty
    } catch {}
  }

  @action
  toggle() {
    if (this.playing) {
      this.pause();
    } else {
      this.play();
    }
  }

  @action
  play(options?: SpotifyApi.PlayParameterObject) {
    this.spotify.client.play(options);
    this.statechart.send(SpotifyEvent.Play);
  }

  @action
  pause() {
    this.spotify.client.pause();
    this.statechart.send(SpotifyEvent.Pause);
  }
}
