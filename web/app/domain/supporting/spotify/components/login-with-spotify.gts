import Component from '@glimmer/component';
import { action } from '@ember/object';
import { service } from '@ember/service';

import config from '@unidancing/app/config/environment';

import type RouterService from '@ember/routing/router-service';

export class LoginWithSpotify extends Component {
  @service declare router: RouterService;

  @action
  loginWithSpotify() {
    localStorage.setItem('redirectAfterLogin', this.router.currentURL as string);
  }

  <template>
    <a href="{{config.workerHostURL}}/spotify/login" {{on "click" this.loginWithSpotify}}>
      Login with Spotify
    </a><br />
    (derzeit nur für ausgewählte Personen - wir arbeiten daran es für alle zugänglich zu machen).
  </template>
}
