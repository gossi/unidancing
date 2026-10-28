import { tracked } from '@glimmer/tracking';

import { dropTask } from 'ember-concurrency';
import SpotifyWebApi from 'spotify-web-api-js';
import SpotifyPlayer from 'spotify-web-playback';
import { fromPromise } from 'xstate';

import { useMachine } from '../statechart';
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

  statechart = useMachine(this, () => ({
    machine: SpotifyMachine.provide({
      // NOTE: every entry references `this` lazily — the setup callback runs
      // while this field is still initializing (class fields evaluate in
      // declaration order), so the methods below would be `undefined` if
      // destructured here. The actor invokes them only after
      // `send('authenticate')`, when construction has long finished.
      guards: {
        hasDevices: () => this.hasDevices()
      },
      actors: {
        connectPlayer: fromPromise<void, { accessToken: string }>(({ input }) =>
          this.connectPlayer(input.accessToken)
        ),
        loadDevices: fromPromise(async () => {
          await this.loadDevices.perform();
        }),
        autoselectDevice: fromPromise(() => this.autoselectDevice()),
        loadPlayback: fromPromise(() => this.loadPlayback())
      }
    })
  }));

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
      // eslint-disable-next-line unicorn/no-null
      this.api.setAccessToken(null);

      return false;
    }
  };

  // DEVICES

  get ready() {
    // `authenticated` is a parallel state (regions: device, playback), so the
    // state value is `{ device: …, playback: … }` — the former flat
    // `matches({ authenticated: 'ready' })` could never be true (and `??`
    // against a boolean short-circuited away the fallback anyway).
    return (
      this.statechart.state?.matches({
        authenticated: {
          device: 'ready'
        }
      }) ?? false
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
      // eslint-disable-next-line unicorn/error-message
      throw new Error();
    }
  };

  loadDevices = dropTask(async () => {
    // eslint-disable-next-line unicorn/no-await-expression-member
    this.devices = (await this.api.getMyDevices()).devices;
  });

  autoselectDevice = async () => {
    if (this.player.ready) {
      // eslint-disable-next-line @typescript-eslint/ban-ts-comment
      // @ts-ignore

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

  // A plain async function: xstate services must return a promise/observable
  // (the former `() => async () => {}` currying handed the inner function
  // itself to the interpreter, which is not a spawnable actor).
  loadPlayback = async () => {
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
