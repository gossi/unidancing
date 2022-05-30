import Component from '@glimmer/component';
import { service, Registry as Services } from '@ember/service';
import SpotifyPlayer from '../player/spotify';
import Spotify from './player/spotify';
import styles from './player.css';

export default class PlayerComponent extends Component {
  @service declare player: Services['player'];

  get spotify() {
    return this.player.player instanceof SpotifyPlayer;
  }

  <template>
    <div class={{styles.player}}>
      {{#if this.spotify}}
        <Spotify />
      {{/if}}
    </div>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Player: typeof PlayerComponent;
  }
}
