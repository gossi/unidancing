import Component from '@glimmer/component';

import { service } from 'ember-polaris-service';
import { and, not } from 'ember-truth-helpers';

import { Icon } from '@hokulea/ember';

import { formatArtists } from '../helpers';
import { SpotifyService } from '../service';
import { LoginWithSpotify } from './login-with-spotify';
import styles from './player.css';

export class SpotifyPlayer extends Component {
  @service(SpotifyService) declare spotify: SpotifyService;

  get client() {
    return this.spotify.client;
  }

  get player() {
    return this.client.player;
  }

  get track() {
    return this.client.track;
  }

  <template>
    <div class={{styles.layout}}>
      <Icon @icon="spotify-logo" @style="fill" class={{styles.spotify}} />

      {{#if (and this.client.authenticated (not this.client.error))}}
        {{#if this.client.ready}}
          <p>
            {{#if this.track}}
              <strong>{{this.track.name}}</strong><br />
              <small>{{formatArtists this.track.artists}}</small>
            {{/if}}
          </p>
          {{!-- {{else if this.client.error}}
          <p>
            <Icon @icon="warning" @style="fill" class={{styles.warning}} />
            Fehler:
            {{this.client.error}}
          </p> --}}
        {{/if}}

      {{else}}
        <div><LoginWithSpotify /></div>
      {{/if}}
    </div>
  </template>
}
