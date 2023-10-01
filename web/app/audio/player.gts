import { SpotifyPlayer } from './spotify';
import { AudioPlayer } from './service';
import styles from './player.css';
import { ability } from 'ember-ability';

const isSpotifyPlayer = ability(({ services }) => () => {
  const { player } = services;

  return player.player === AudioPlayer.Spotify;
});

const Player = <template>
  {{#if (isSpotifyPlayer)}}
    <div class={{styles.player}}>
      <SpotifyPlayer />
    </div>
  {{/if}}
</template>

export default Player;
