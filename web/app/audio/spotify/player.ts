import { action } from '@ember/object';

import type { SpotifyClient } from './client';

export default class SpotifyPlayer {
  #client: SpotifyClient;

  constructor(client: SpotifyClient) {
    this.#client = client;
  }

  get playing() {
    return this.#client.playing;
  }

  @action
  async selectDevice(device: SpotifyApi.UserDevice) {
    this.#client.selectDevice(device);
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
    this.#client.play(options);
  }

  @action
  pause() {
    this.#client.pause();
  }
}
