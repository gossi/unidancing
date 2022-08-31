import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import SpotifyWebApi from 'spotify-web-api-js';
import { deserialize } from '../utils/serde';
import { task, timeout } from 'ember-concurrency';
import { taskFor } from 'ember-concurrency-ts';
import config from '@unidancing/app/config/environment';

interface SpotifyStorage {
  accessToken?: string;
  refreshToken?: string;
}

export default class SpotifyService extends Service {
  @tracked authed = false;
  #storage: SpotifyStorage;

  redirectAfterLogin?: string;

  client = new SpotifyWebApi();

  constructor() {
    super();

    const data = localStorage.getItem('spotify');
    this.#storage = data ? JSON.parse(data) : {};

    this.restore();
  }

  async restore() {
    try {
      if (this.#storage.accessToken) {
        this.client.setAccessToken(this.#storage.accessToken);
        await this.client.getMe();
        this.authed = true;
      }
    } catch (e) {
      this.client.setAccessToken(null);
      delete this.#storage.accessToken;
    }

    if (!this.authed && this.#storage.refreshToken) {
      await this.refresh(this.#storage.refreshToken);
      if (!this.authed) {
        delete this.#storage.refreshToken;
      }
    }

    this.persist();
  }

  async refresh(token: string) {
    try {
      const response = await fetch(
        `${config.workerHostURL}/spotify/refresh?token=${token}`
      );

      if (response.status === 200) {
        this.auth(deserialize(await response.json()));
      }
    } catch (_e) {
      // do not do something here
    }
  }

  auth({
    accessToken,
    refreshToken,
    expiresIn
  }: SpotifyStorage & { expiresIn?: string }) {
    this.#storage = { accessToken, refreshToken };
    this.persist();

    if (refreshToken && expiresIn) {
      taskFor(this.refresher).perform(
        refreshToken,
        Number.parseInt(expiresIn, 10) * 1000 - 300
      );
    }

    if (accessToken) {
      this.client.setAccessToken(accessToken);
      this.authed = true;
    }
  }

  persist() {
    localStorage.setItem('spotify', JSON.stringify(this.#storage));
  }

  @task *refresher(refreshToken: string, timer: number) {
    yield timeout(timer);
    this.refresh(refreshToken);
  }
}

declare module '@ember/service' {
  interface Registry {
    spotify: SpotifyService;
  }
}
