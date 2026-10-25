import * as oauth from 'oauth4webapi';

interface OauthClientConfig {
  issuer: string;
  clientId: string;
  clientSecret: string;
  /**
   * Spotify's registered redirect URI — this worker's own
   * `GET /spotify/authenticated` anchor. It must be byte-for-byte identical
   * in the authorization request and the token exchange, and is validated by
   * Spotify against the app's registered redirect URIs.
   */
  redirectURI: string;
  scopes: string[];
}

/** Parameters the FE minted (and stored the verifier for) before login. */
interface AuthorizationParams {
  codeChallenge: string;
  state: string;
}

/**
 * A confidential OAuth client for Spotify.
 *
 * PKCE is owned by the frontend: it generates and stores the `code_verifier`,
 * and only the derived `code_challenge` is seen here on the way out. On the
 * way back the FE hands the `code` and its stored verifier to {@link exchange},
 * which still authenticates this worker as a confidential client with the
 * secret. That binds the code to this browser session (mitigating code
 * injection) while keeping the secret off the client.
 */
class OauthClient {
  #config: OauthClientConfig;
  #as!: oauth.AuthorizationServer;
  #client: oauth.Client;
  #clientAuth: oauth.ClientAuth;
  #serverRead?: Promise<void>;

  constructor(config: OauthClientConfig) {
    this.#config = config;
    this.#client = {
      client_id: this.#config.clientId
    };
    this.#clientAuth = oauth.ClientSecretBasic(this.#config.clientSecret);
  }

  async readServer() {
    // Cache the discovery promise so concurrent first requests share one read.
    this.#serverRead ??= (async () => {
      const issuer = new URL(this.#config.issuer);
      const response = await oauth.discoveryRequest(issuer, {
        algorithm: 'oauth2'
      });

      this.#as = await oauth.processDiscoveryResponse(issuer, response);
    })();

    return this.#serverRead;
  }

  /**
   * Build the Spotify authorization URL from the FE-supplied challenge and
   * state. No verifier is generated or retained here.
   */
  getAuthorizationURL({ codeChallenge, state }: AuthorizationParams): URL {
    const loginUrl = new URL(this.#as.authorization_endpoint as string);

    loginUrl.searchParams.set('client_id', this.#config.clientId);
    loginUrl.searchParams.set('code_challenge', codeChallenge);
    loginUrl.searchParams.set('code_challenge_method', 'S256');
    loginUrl.searchParams.set('redirect_uri', this.#config.redirectURI);
    loginUrl.searchParams.set('response_type', 'code');
    loginUrl.searchParams.set('state', state);
    loginUrl.searchParams.set('scope', this.#config.scopes.join(' '));

    return loginUrl;
  }

  /**
   * Exchange an authorization `code` for tokens, proving possession of the
   * frontend's stored `codeVerifier`.
   *
   * Note: this goes through `genericTokenEndpointRequest` rather than
   * `authorizationCodeGrantRequest` because the latter demands its params
   * originate from `validateAuthResponse()` (a runtime brand-check) — a
   * precondition for parsing raw browser-callback URLs. The frontend already
   * validated the authorization response (state check) and delivered parsed
   * JSON here, so we assert what we know directly. The request both paths
   * build is identical.
   */
  async exchange(code: string, codeVerifier: string): Promise<oauth.TokenEndpointResponse> {
    const response = await oauth.genericTokenEndpointRequest(
      this.#as,
      this.#client,
      this.#clientAuth,
      'authorization_code',
      {
        code,
        redirect_uri: this.#config.redirectURI,
        code_verifier: codeVerifier
      }
    );

    return oauth.processAuthorizationCodeResponse(this.#as, this.#client, response);
  }

  async refresh(token: string): Promise<oauth.TokenEndpointResponse> {
    const response = await oauth.refreshTokenGrantRequest(
      this.#as,
      this.#client,
      this.#clientAuth,
      token
    );

    return oauth.processRefreshTokenResponse(this.#as, this.#client, response);
  }
}

export { OauthClient };
