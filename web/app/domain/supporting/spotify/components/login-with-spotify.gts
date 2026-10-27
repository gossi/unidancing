import Component from '@glimmer/component';
import { action } from '@ember/object';
import { service } from '@ember/service';

import { service as polarisService } from 'ember-polaris-service';

import { Button } from '@hokulea/ember';

import { SpotifyService } from '../service';

import type RouterService from '@ember/routing/router-service';

export class LoginWithSpotify extends Component {
  @service declare router: RouterService;
  @polarisService(SpotifyService) declare spotify: SpotifyService;

  @action
  loginWithSpotify() {
    // The PKCE challenge must be minted at click time, so this cannot be a
    // static href anymore — `startLogin` generates verifier/state, stores the
    // pair in session storage and navigates to the worker's authorize relay.
    void this.spotify.startLogin(this.router.currentURL ?? undefined);
  }

  <template>
    <div class="scene">
      <Button @importance="subtle" @spacing="-1" @push={{this.loginWithSpotify}}>
        Login with Spotify
      </Button>
      <p>(derzeit nur für ausgewählte Personen - wir arbeiten daran es für alle zugänglich zu
        machen).</p>
    </div>
    <style scoped>
      .scene {
        display: flex;
        flex-wrap: wrap;
        gap: var(--s-4);
        align-items: center;
      }
    </style>
  </template>
}
