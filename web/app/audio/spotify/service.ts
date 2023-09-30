import Service from '@ember/service';

import config from '@unidancing/app/config/environment';
import { task, timeout } from 'ember-concurrency';

import { deserialize } from '../../utils/serde';
import { SpotifyClient } from './client';

interface SpotifyStorage {
  accessToken?: string;
  refreshToken?: string;
}

/**
 * The Spotify service authenticates against their API and manages the
 * connection.
 */
export default class SpotifyService extends Service {
  #storage: SpotifyStorage;

  redirectAfterLogin?: string;

  client = SpotifyClient.from(this, () => []);

  constructor() {
    super();

    const data = localStorage.getItem('spotify');

    this.#storage = data ? JSON.parse(data) : {};

    this.restore();
  }

  async restore() {
    console.log('SpotifyService.restore', this.#storage);

    if (this.#storage.accessToken) {
      await this.client.authenticate(this.#storage.accessToken);
    }

    if (!this.client.authenticated && this.#storage.refreshToken) {
      await this.refresh(this.#storage.refreshToken);

      if (!this.client.authenticated) {
        delete this.#storage.refreshToken;
      }
    }

    this.persist();
  }

  async refresh(token: string) {
    console.log('SpotifyService.refresh with token', token);

    try {
      const response = await fetch(`${config.workerHostURL}/spotify/refresh?token=${token}`);

      if (response.status === 200) {
        this.authenticate(deserialize(await response.json()));
      }
    } catch (_e) {
      // do not do something here
    }
  }

  authenticate({ accessToken, refreshToken, expiresIn }: SpotifyStorage & { expiresIn?: string }) {
    console.log('SpotifyService.authenticate', { accessToken, refreshToken, expiresIn });

    this.#storage = { accessToken, refreshToken };
    this.persist();

    if (refreshToken && expiresIn) {
      this.refresher.perform(refreshToken, Number.parseInt(expiresIn, 10) * 1000 - 300);
    }

    if (accessToken) {
      this.client.authenticate(accessToken);
    }
  }

  persist() {
    localStorage.setItem('spotify', JSON.stringify(this.#storage));
  }

  refresher = task(async (refreshToken: string, timer: number) => {
    await timeout(timer);
    this.refresh(refreshToken);
  });
}

declare module '@ember/service' {
  interface Registry {
    spotify: SpotifyService;
  }
}
