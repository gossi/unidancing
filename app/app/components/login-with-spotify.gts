import Component from '@glimmer/component';
import { on } from '@ember/modifier';
import config from '@unidance-coach/app/config/environment';
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
    </a>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    LoginWithSpotify: typeof LoginWithSpotifyComponent;
  }
}
