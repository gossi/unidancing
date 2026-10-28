import config from '@unidancing/app/config/environment';
import { task, timeout } from 'ember-concurrency';
import Service from 'ember-polaris-service';

import {
  createAuthState,
  createCodeChallenge,
  createCodeVerifier,
  saveAuthAttempt
} from '../auth/pkce';
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

  client = new SpotifyClient();

  constructor(scope: Scope) {
    super(scope);

    if (!isSSR()) {
      const data = localStorage.getItem('spotify');

      this.#storage = data ? (JSON.parse(data) as SpotifyStorage) : {};

      void this.restore();
    }
  }

  /**
   * Begin a PKCE login: mint a code verifier + state envelope (nonce and this
   * tab's origin), stash them — plus where to return afterwards — in this
   * tab's session storage, and hand the derived S256 challenge and state to
   * the worker, which relays them to Spotify's authorize endpoint. The
   * verifier itself never leaves the client.
   */
  async startLogin(returnTo?: string) {
    const codeVerifier = createCodeVerifier();
    const codeChallenge = await createCodeChallenge(codeVerifier);
    const state = createAuthState();

    saveAuthAttempt({ codeVerifier, state, returnTo });

    const loginUrl = new URL(`${config.workerHostURL}/spotify/login`);

    loginUrl.searchParams.set('code_challenge', codeChallenge);
    loginUrl.searchParams.set('state', state);

    globalThis.location.assign(loginUrl.href);
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
        this.authenticate(deserialize((await response.json()) as Record<string, string>));
      }
    } catch {
      // do not do something here
    }
  }

  authenticate({
    accessToken,
    refreshToken,
    expiresIn
  }: SpotifyStorage & { expiresIn?: string | number }) {
    this.#storage = { accessToken, refreshToken };
    this.persist();

    if (refreshToken && expiresIn) {
      void this.refresher.perform(refreshToken, Number(expiresIn) * 1000 - 300);
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
