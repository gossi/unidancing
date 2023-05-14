import Component from '@glimmer/component';
import { service, Registry as Services } from '@ember/service';
import SpotifyUI from '../audio/spotify/ui';
import { Player } from '../audio/player';
import styles from './player.css';
import eq from 'ember-truth-helpers/helpers/equal';

export default class PlayerComponent extends Component {
  @service declare player: Services['player'];

  <template>
    {{#if (eq this.player.player Player.Spotify)}}
      <div class={{styles.player}}>
        <SpotifyUI />
      </div>
    {{/if}}
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Player: typeof PlayerComponent;
  }
}
