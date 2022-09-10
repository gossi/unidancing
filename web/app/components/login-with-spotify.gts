import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import config from '@unidancing/app/config/environment';
import {action} from '@ember/object';
import { service, Registry as Services } from '@ember/service';

export default class LoginWithSpotifyComponent extends Component {
  @service declare router: Services['router'];

  @action
  loginWithSpotify() {
    localStorage.setItem('redirectAfterLogin', this.router.currentURL);
  }

  <template>
    <a
      href='{{config.workerHostURL}}/spotify/login'
      {{on "click" this.loginWithSpotify}}
    >
      Login with Spotify
    </a><br>
    (Login mit Spotify benötigt derzeit noch eine manuelle Freischaltung, bitte
    bei gossi melden).
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    LoginWithSpotify: typeof LoginWithSpotifyComponent;
  }
}
