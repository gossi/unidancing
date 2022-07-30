import Component from '@glimmer/component';
import { service, Registry as Services } from '@ember/service';
import { LoginWithSpotify } from '../actions/login-with-spotify';
import { command, commandFor } from 'ember-command';
import { on } from '@ember/modifier';

export default class PlayerComponent extends Component {

  @command
  loginWithSpotify = commandFor([
    new LoginWithSpotify()
  ]);

  <template>
    <a
      href='http://localhost:8787/spotify/login'
      {{on "click" this.loginWithSpotify}}
    >
      Login with Spotify
    </a>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Player: typeof PlayerComponent;
  }
}
