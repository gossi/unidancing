import { sentry } from '@hono/sentry';
import { cors } from 'hono/cors';
import { Hono } from 'hono/tiny';
import * as oauth from 'oauth4webapi';

import { decodeAuthState } from './auth-state';
import { OauthClient } from './oauth-client';
import { matchOrigin } from './origins';

export interface Env {
  ENVIRONMENT: 'dev' | 'staging' | 'production';
  /** This worker's public root — its own URL is Spotify's registered callback. */
  WORKER_ROOT: string;
  /** Comma-separated FE origins the callback relay may target. Public config. */
  FE_ORIGIN_ALLOWLIST: string;
  SPOTIFY_CLIENT_ID: string;
  SPOTIFY_CLIENT_SECRET: string;
  SENTRY_DSN: string;
}

interface TokenExchangeRequest {
  code?: string;
  code_verifier?: string;
}

// The client is stateless now (no PKCE verifier lives here), so one instance
// per isolate is fine — only the OAuth discovery read is expensive, and the
// secret is fixed for the worker's lifetime.
let spotifyClientPromise: Promise<OauthClient> | undefined;

function getSpotifyClient(env: Env): Promise<OauthClient> {
  spotifyClientPromise ??= (async () => {
    const client = new OauthClient({
      issuer: 'https://accounts.spotify.com',
      clientId: env.SPOTIFY_CLIENT_ID,
      clientSecret: env.SPOTIFY_CLIENT_SECRET,
      // PKCE demands that the callback land where the verifier lives — the
      // browser. So Spotify only ever redirects to this worker's own anchor
      // URI (fixed per environment in the Spotify console), and the GET
      // handler below relays on to the FE origin carried in `state`.
      redirectURI: `${env.WORKER_ROOT}/spotify/authenticated`,
      scopes: [
        'playlist-read-collaborative',
        'playlist-read-private',
        'user-read-playback-state',
        'user-modify-playback-state',
        'user-read-email',
        'user-read-private',
        'streaming'
      ]
    });

    await client.readServer();

    return client;
  })();

  return spotifyClientPromise;
}

const app = new Hono<{
  Bindings: Env;
  Variables: {
    spotify: OauthClient;
  };
}>();

app.use(cors());
app.use((c, next) => sentry({ environment: c.env.ENVIRONMENT })(c, next));

app.use('/spotify/*', async (c, next) => {
  c.set('spotify', await getSpotifyClient(c.env));

  await next();
});

/**
 * Relay to Spotify's authorization endpoint. The frontend mints the PKCE
 * verifier, derives this challenge and stores the pair plus `state` in
 * session storage; the worker only forwards them (keeping client id and
 * scopes server side).
 */
app.get('/spotify/login', (c) => {
  const codeChallenge = c.req.query('code_challenge');
  const state = c.req.query('state');

  if (!codeChallenge || !state) {
    return c.json(
      {
        error: 'invalid_request',
        error_description: 'code_challenge and state are required'
      },
      400
    );
  }

  const spotify = c.get('spotify');
  const loginUrl = spotify.getAuthorizationURL({ codeChallenge, state });

  return c.redirect(loginUrl.href);
});

/**
 * Spotify's registered callback landing point. The worker cannot and must not
 * redeem the `code` itself — the PKCE verifier lives in the originating tab.
 * So this is a pure relay: decode the `state` envelope, require its embedded
 * origin to match FE_ORIGIN_ALLOWLIST (no open redirect), then forward the
 * callback params to that FE's /auth/spotify. Anything unverifiable ends here
 * with a dead-end page; nothing attacker-influenced becomes a redirect.
 */
app.get('/spotify/authenticated', (c) => {
  const state = decodeAuthState(c.req.query('state'));

  if (!state || !matchOrigin(state.o, c.env.FE_ORIGIN_ALLOWLIST)) {
    return c.html(
      '<!doctype html><html><head><meta charset="utf-8"><title>Spotify login</title></head>' +
        '<body><p>This Spotify login callback could not be verified. Please start the login again.</p></body></html>',
      400
    );
  }

  const callback = new URL('/auth/spotify', state.o);

  for (const key of ['code', 'state', 'error', 'error_description'] as const) {
    const value = c.req.query(key);

    if (value !== undefined) {
      callback.searchParams.set(key, value);
    }
  }

  return c.redirect(callback.href);
});

/**
 * Complete the PKCE flow on behalf of the frontend: redeem the `code` with the
 * FE-supplied verifier, authenticated by this client's secret. Tokens travel
 * back as a JSON response — never through a redirect URL.
 */
app.post('/spotify/authenticated', async (c) => {
  let body: TokenExchangeRequest | undefined;

  try {
    body = await c.req.json<TokenExchangeRequest>();
  } catch {
    // not a JSON body — handled by the validation below
  }

  if (!body?.code || !body.code_verifier) {
    return c.json(
      {
        error: 'invalid_request',
        error_description: 'code and code_verifier are required'
      },
      400
    );
  }

  const spotify = c.get('spotify');

  try {
    const result = await spotify.exchange(body.code, body.code_verifier);

    return c.json({
      access_token: result.access_token,
      refresh_token: result.refresh_token,
      expires_in: result.expires_in
    });
  } catch (error) {
    // Surface OAuth protocol failures (expired code, bad verifier, revoked
    // client…) to the frontend; anything unexpected goes to Sentry.
    if (error instanceof oauth.ResponseBodyError) {
      return c.json(
        {
          error: error.error,
          error_description: error.error_description
        },
        400
      );
    }

    throw error;
  }
});

app.get('/spotify/refresh', async (c) => {
  const token = c.req.query('token');

  if (!token) {
    return c.notFound();
  }

  const spotify = c.get('spotify');
  const result = await spotify.refresh(token);

  return c.json(result);
});

app.get('/fail', () => {
  throw new Error('boom');
});

export default app;
