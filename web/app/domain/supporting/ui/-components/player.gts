import { ability } from 'ember-ability';

import { AudioPlayer, AudioService } from '../../audio';
import { SpotifyPlayer } from '../../spotify';
import styles from './player.css';

const isSpotifyPlayer = ability((sweetOwner) => () => {
  return sweetOwner.service(AudioService).player === AudioPlayer.Spotify;
});

const Player = <template>
  {{#if (isSpotifyPlayer)}}
    <div class={{styles.player}} data-player>
      <SpotifyPlayer />
    </div>
  {{/if}}
</template>;

export { Player };
