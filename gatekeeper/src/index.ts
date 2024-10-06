/**
 * Welcome to Cloudflare Workers! This is your first worker.
 *
 * - Run `wrangler dev src/index.ts` in your terminal to start a development server
 * - Open a browser tab at http://localhost:8787/ to see your worker in action
 * - Run `wrangler publish src/index.ts --name my-worker` to publish your worker
 *
 * Learn more at https://developers.cloudflare.com/workers/
 */

import { Router } from 'itty-router';
import { OauthClient } from './oauth-client';

export interface Env {
  // Example binding to KV. Learn more at https://developers.cloudflare.com/workers/runtime-apis/kv/
  // MY_KV_NAMESPACE: KVNamespace;
  //
  // Example binding to Durable Object. Learn more at https://developers.cloudflare.com/workers/runtime-apis/durable-objects/
  // MY_DURABLE_OBJECT: DurableObjectNamespace;
  //
  // Example binding to R2. Learn more at https://developers.cloudflare.com/workers/runtime-apis/r2/
  // MY_BUCKET: R2Bucket;

  // SPOTIFY_REDIRECT_URI: string;
  SPOTIFY_CLIENT_ID: string;
  SPOTIFY_CLIENT_SECRET: string;
  WORKER_ROOT: string;
  APP_ROOT: string;
}

let spotifyClient: OauthClient;
async function getSpotifyClient(env: Env): Promise<OauthClient> {
  if (!spotifyClient) {
    spotifyClient = new OauthClient({
      issuer: 'https://accounts.spotify.com',
      clientId: env.SPOTIFY_CLIENT_ID,
      clientSecret: env.SPOTIFY_CLIENT_SECRET,
      grantRedirectURI: `${env.WORKER_ROOT}/spotify/authenticated`,
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
    await spotifyClient.readServer();
  }

  return spotifyClient;
}

const router = Router();

router.get('/spotify/login', async (_req, env: Env) => {
  const spotify = await getSpotifyClient(env);
  const loginUrl = await spotify.getAuthorizationURL();
  return Response.redirect(loginUrl.toString());
});

router.get('/spotify/authenticated', async (req, env: Env) => {
  const spotify = await getSpotifyClient(env);
  const result = await spotify.grantCode(req.url);

  const redirectUrl = new URL(`${env.APP_ROOT}/auth/spotify`);
  redirectUrl.searchParams.set('access_token', result.access_token);
  redirectUrl.searchParams.set('refresh_token', result.refresh_token as string);
  redirectUrl.searchParams.set('expires_in', `${result.expires_in}`);

  return Response.redirect(redirectUrl.toString());
});

router.get('/spotify/refresh', async (req, env) => {
  const url = new URL(req.url);
  if (!url.searchParams.has('token')) {
    return new Response('', {
      status: 400,
      statusText: 'Missing token query parameter'
    });
  }

  const spotify = await getSpotifyClient(env);
  const result = await spotify.refresh(url.searchParams.get('token') as string);

  return new Response(JSON.stringify(result), {
    status: 200,
    headers: {
      'content-type': 'application/json;charset=UTF-8'
    }
  });
});

// Reference: https://developers.cloudflare.com/workers/examples/cors-header-proxy
const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET,HEAD,POST,OPTIONS',
  'Access-Control-Max-Age': '86400'
};

function handleOptions(request: Request) {
  // Make sure the necessary headers are present
  // for this to be a valid pre-flight request
  const headers = request.headers;
  if (
    headers.get('Origin') !== null &&
    headers.get('Access-Control-Request-Method') !== null &&
    headers.get('Access-Control-Request-Headers') !== null
  ) {
    // Handle CORS pre-flight request.
    // If you want to check or reject the requested method + headers
    // you can do that here.
    const respHeaders = {
      ...corsHeaders,
      // Allow all future content Request headers to go back to browser
      // such as Authorization (Bearer) or X-Client-Name-Version
      'Access-Control-Allow-Headers': request.headers.get(
        'Access-Control-Request-Headers'
      )
    };
    return new Response(null, {
      // @ts-ignore
      headers: respHeaders
    });
  } else {
    // Handle standard OPTIONS request.
    // If you want to allow other HTTP Methods, you can do that here.
    return new Response(null, {
      headers: {
        Allow: 'GET, HEAD, POST, OPTIONS'
      }
    });
  }
}

export default {
  async fetch(
    request: Request,
    env: Env
    // ctx: ExecutionContext
  ): Promise<Response> {
    let response;
    if (request.method === 'OPTIONS') {
      response = handleOptions(request);
    } else {
      response = await router.handle(request, env);

      if (!response.redirected) {
        response = new Response(response.body, response);
        response.headers.set('Access-Control-Allow-Origin', '*');
        response.headers.set(
          'Access-Control-Allow-Methods',
          'GET, POST, PUT, DELETE, OPTIONS'
        );
      }
    }

    return response;
  }
};
