import config from '@unidancing/app/config/environment';
import { task, timeout } from 'ember-concurrency';
import Service from 'ember-polaris-service';

import { deserialize, isSSR } from '../utils';
import { SpotifyClient } from './client';

import type { Scope } from 'ember-polaris-service';

interface SpotifyStorage {
  accessToken?: string;
  refreshToken?: string;
}

/**
 * The Spotify service authenticates against their API and manages the
 * connection.
 */
export class SpotifyService extends Service {
  #storage: SpotifyStorage = {};

  redirectAfterLogin?: string;

  client = new SpotifyClient();

  constructor(scope: Scope) {
    super(scope);

    if (!isSSR()) {
      const data = localStorage.getItem('spotify');

      this.#storage = data ? (JSON.parse(data) as SpotifyStorage) : {};

      void this.restore();
    }
  }

  async restore() {
    if (this.#storage.accessToken) {
      await this.client.authenticate(this.#storage.accessToken);
    }

    if (!this.client.authenticated && this.#storage.refreshToken) {
      await this.refresh(this.#storage.refreshToken);

      delete this.#storage.refreshToken;
    }

    this.persist();
  }

  async refresh(token: string) {
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
    this.#storage = { accessToken, refreshToken };
    this.persist();

    if (refreshToken && expiresIn) {
      void this.refresher.perform(refreshToken, Number.parseInt(expiresIn, 10) * 1000 - 300);
    }

    if (accessToken) {
      void this.client.authenticate(accessToken);
    }
  }

  persist() {
    if (!isSSR()) {
      localStorage.setItem('spotify', JSON.stringify(this.#storage));
    }
  }

  refresher = task(async (refreshToken: string, timer: number) => {
    await timeout(timer);
    await this.refresh(refreshToken);
  });
}

declare module '@ember/service' {
  interface Registry {
    spotify: SpotifyService;
  }
}
