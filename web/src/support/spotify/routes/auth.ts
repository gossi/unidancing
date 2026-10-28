import Route from '@ember/routing/route';
import { service } from '@ember/service';

import config from '@unidancing/app/config/environment';
import { service as polarisService } from 'ember-polaris-service';

import { clearAuthAttempt, loadAuthAttempt } from '../../auth/pkce';
import { deserialize, isSSR } from '../../utils';
import { SpotifyService } from '../service';

import type { AuthAttempt } from '../../auth/pkce';
import type RouteInfo from '@ember/routing/route-info';
import type RouterService from '@ember/routing/router-service';

type RouteModel = object | string | number;
type RouteArgs = Parameters<RouterService['urlFor']>;

function makeRouteArgs({
  name,
  models,
  query
}: {
  name: string;
  models: RouteModel[];
  query?: Record<string, unknown>;
}): RouteArgs {
  if (query) {
    return [name, ...models, { queryParams: query }];
  }

  return [name, ...models];
}

/**
 * Landing point of the Spotify PKCE callback started by
 * `SpotifyService.startLogin`. Spotify redirects here with `code` + `state`;
 * the state is checked against the attempt this tab stored before leaving,
 * and `code` + the stored verifier are handed to the worker for the token
 * exchange — tokens arrive as JSON, never through the URL.
 */
export class SpotifyAuthRoute extends Route {
  @polarisService(SpotifyService) declare spotify: SpotifyService;
  @service declare router: RouterService;

  activate() {
    if (isSSR()) {
      return;
    }

    const params = new URLSearchParams(globalThis.location.search);

    if (!params.has('code') && !params.has('error')) {
      // Plain navigation to /auth/spotify — nothing to complete.
      void this.router.transitionTo('application');

      return;
    }

    // Consume the attempt exactly once, before any await.
    const attempt = loadAuthAttempt();

    clearAuthAttempt();

    // Keep `code`/`state` out of the address bar and the browser history.
    globalThis.history.replaceState({}, '', globalThis.location.pathname);

    void this.completeLogin(params, attempt);
  }

  private async completeLogin(params: URLSearchParams, attempt: AuthAttempt | undefined) {
    const code = params.get('code');
    const state = params.get('state');
    const error = params.get('error');
    const codeVerifier = attempt?.codeVerifier;
    const expectedState = attempt?.state;

    // Denied consent or a `state` mismatch (forged/stale callback): continue
    // as a guest. The state is compared verbatim — it doubles as the CSRF
    // nonce and the worker's routing envelope, so nothing may have changed.
    if (error || !code || !codeVerifier || !expectedState || state !== expectedState) {
      this.continueAfterLogin(attempt?.returnTo);

      return;
    }

    try {
      const response = await fetch(`${config.workerHostURL}/spotify/authenticated`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ code, code_verifier: codeVerifier })
      });

      if (response.ok) {
        const tokens = deserialize((await response.json()) as Record<string, unknown>) as {
          accessToken?: string;
          refreshToken?: string;
          expiresIn?: string | number;
        };

        this.spotify.authenticate(tokens);
      }
    } catch {
      // Exchange failed (network or server) — continue as guest.
    }

    this.continueAfterLogin(attempt.returnTo);
  }

  private continueAfterLogin(returnTo?: string) {
    if (!returnTo) {
      void this.router.transitionTo('application');

      return;
    }

    const [routeURL, qp] = returnTo.split('?') as [string, string];
    const query = Object.fromEntries(new URLSearchParams(qp));

    // ok, so "transitionTo(url)" will drop the query params, so let's do
    // this fancy thing here:
    const route = this.router.recognize(routeURL) as RouteInfo;
    const routeArgs = makeRouteArgs({
      name: route.name,
      models: Object.values(route.params as object) as RouteModel[],
      query: Object.keys(query).length > 0 ? query : undefined
    });

    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    // @ts-ignore glint, wh00t ?
    void this.router.transitionTo(...routeArgs);
  }
}
