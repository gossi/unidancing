import { SpotifyPlayer } from '../../spotify';
import { AudioPlayer, AudioService } from '../service';
import styles from './player.css';
import { ability } from 'ember-ability';

const isSpotifyPlayer = ability((sweetOwner) => () => {
  return sweetOwner.service(AudioService).player === AudioPlayer.Spotify;
});

const Player = <template>
  {{#if (isSpotifyPlayer)}}
    <div class={{styles.player}}>
      <SpotifyPlayer />
    </div>
  {{/if}}
</template>

export { Player };
