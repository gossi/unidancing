import Component from '@glimmer/component';
import { LoginWithSpotify } from '../actions/login-with-spotify';
import { command, commandFor } from 'ember-command';
import { on } from '@ember/modifier';
import config from 'unidance-coach/config/environment';

export default class LoginWithSpotifyComponent extends Component {

  @command
  loginWithSpotify = commandFor([
    new LoginWithSpotify()
  ]);

  <template>
    <a
      href='{{config.workerHostURL}}/spotify/login'
      {{on "click" this.loginWithSpotify}}
    >
      Login with Spotify
    </a>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    LoginWithSpotify: typeof LoginWithSpotifyComponent;
  }
}
