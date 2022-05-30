import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import SpotifyWebApi from 'spotify-web-api-js';

export default class SpotifyService extends Service {
  @tracked authed = false;

  client = new SpotifyWebApi();

  constructor() {
    super();

    const token = localStorage.getItem('token');
    if (token) {
      this.grant(token);
    }
  }

  grant(accessToken: string) {
    localStorage.setItem('token', accessToken);
    this.client.setAccessToken(accessToken);

    this.authed = true;
  }
}

declare module '@ember/service' {
  interface Registry {
    spotify: SpotifyService;
  }
}
