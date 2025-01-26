import * as oauth from 'oauth4webapi';

interface OauthClientConfig {
  issuer: string;
  clientId: string;
  clientSecret: string;
  grantRedirectURI: string;
  scopes: string[];
}

class OauthClient {
  #codeVerifier: string;
  #config: OauthClientConfig;
  #as!: oauth.AuthorizationServer;
  #client: oauth.Client;
  #clientAuth: oauth.ClientAuth;

  constructor(config: OauthClientConfig) {
    this.#config = config;
    this.#codeVerifier = oauth.generateRandomCodeVerifier();
    this.#client = {
      // eslint-disable-next-line @typescript-eslint/naming-convention
      client_id: this.#config.clientId
    };
    this.#clientAuth = oauth.ClientSecretBasic(this.#config.clientSecret);
  }

  async readServer() {
    // eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
    if (!this.#as) {
      const issuer = new URL(this.#config.issuer);
      const response = await oauth.discoveryRequest(issuer, {
        algorithm: 'oauth2'
      });

      this.#as = await oauth.processDiscoveryResponse(issuer, response);
    }
  }

  async getAuthorizationURL() {
    const codeChallenge = await oauth.calculatePKCECodeChallenge(this.#codeVerifier);
    const codeChallengeMethod = 'S256';

    const loginUrl = new URL(this.#as.authorization_endpoint as string);

    loginUrl.searchParams.set('client_id', this.#config.clientId);
    loginUrl.searchParams.set('code_challenge', codeChallenge);
    loginUrl.searchParams.set('code_challenge_method', codeChallengeMethod);
    loginUrl.searchParams.set('redirect_uri', this.#config.grantRedirectURI);
    loginUrl.searchParams.set('response_type', 'code');
    loginUrl.searchParams.set('scope', this.#config.scopes.join(' '));

    return loginUrl;
  }

  async grantCode(url: string | URL): Promise<oauth.TokenEndpointResponse> {
    const params = oauth.validateAuthResponse(
      this.#as,
      this.#client,
      typeof url === 'string' ? new URL(url) : url,
      oauth.expectNoState
    );

    const response = await oauth.authorizationCodeGrantRequest(
      this.#as,
      this.#client,
      this.#clientAuth,
      params,
      this.#config.grantRedirectURI,
      this.#codeVerifier
    );

    const result = await oauth.processAuthorizationCodeResponse(this.#as, this.#client, response);

    return result;
  }

  async refresh(token: string): Promise<oauth.TokenEndpointResponse> {
    const response = await oauth.refreshTokenGrantRequest(
      this.#as,
      this.#client,
      this.#clientAuth,
      token
    );

    const result = await oauth.processRefreshTokenResponse(this.#as, this.#client, response);

    return result;
  }
}

export { OauthClient };
