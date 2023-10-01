import * as oauth from 'oauth4webapi'

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

  constructor(config: OauthClientConfig) {
    this.#config = config;
    this.#codeVerifier = oauth.generateRandomCodeVerifier();
    this.#client = {
      client_id: this.#config.clientId,
      client_secret: this.#config.clientSecret
    };
  }

  async readServer() {
    if (!this.#as) {
      const issuer = new URL(this.#config.issuer);
      const response = await oauth.discoveryRequest(issuer, {
        algorithm: 'oauth2'
      });
      this.#as = await oauth.processDiscoveryResponse(issuer, response);
    }
  }

  async getAuthorizationURL() {
    const codeChallenge = await oauth.calculatePKCECodeChallenge(
      this.#codeVerifier
    );
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

  async grantCode(url: string | URL): Promise<oauth.OAuth2TokenEndpointResponse> {
    const params = oauth.validateAuthResponse(
      this.#as,
      this.#client,
      typeof url === 'string' ? new URL(url) : url,
      oauth.expectNoState
    );

    if (oauth.isOAuth2Error(params)) {
      console.log('error', params);
      throw new Error(); // Handle OAuth 2.0 redirect error
    }

    const response = await oauth.authorizationCodeGrantRequest(
      this.#as,
      this.#client,
      params,
      this.#config.grantRedirectURI,
      this.#codeVerifier
    );

    let challenges: oauth.WWWAuthenticateChallenge[] | undefined;
    if ((challenges = oauth.parseWwwAuthenticateChallenges(response))) {
      for (const challenge of challenges) {
        console.log('challenge', challenge);
      }
      throw new Error(); // Handle www-authenticate challenges as needed
    }

    // this here would be the official way, but returns an error...
    const result = await oauth.processAuthorizationCodeOAuth2Response(
      this.#as,
      this.#client,
      response
    );

    if (oauth.isOAuth2Error(result)) {
      console.error(result);
      throw new Error(); // Handle OAuth 2.0 response body error
    }

    return result;
  }

  async refresh(token: string): Promise<oauth.TokenEndpointResponse> {
    const response = await oauth.refreshTokenGrantRequest(
      this.#as,
      this.#client,
      token
    );

    // ... same as above... :/
    // const result = await response.json();

    // return result;

    const result = await oauth.processRefreshTokenResponse(
      this.#as,
      this.#client,
      response
    );

    if (oauth.isOAuth2Error(result)) {
      console.error(result);
      throw new Error(); // Handle OAuth 2.0 response body error
    }

    return result;
  }
}

export { OauthClient };
