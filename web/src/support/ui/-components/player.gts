import { ability } from 'ember-ability';

import { AudioPlayer, AudioService } from '../../audio';
import { SpotifyPlayer } from '../../spotify';

const isSpotifyPlayer = ability(({ service }) => () => {
  return service(AudioService).player === AudioPlayer.Spotify;
});

const Player = <template>
  {{#if (isSpotifyPlayer)}}
    <div class="player" data-player>
      <SpotifyPlayer />
    </div>
  {{/if}}
  <style scoped>
    .player {
      position: fixed;
      bottom: 0;

      display: grid;
      grid-template-columns:
        minmax(var(--spacing-container0), 1fr) minmax(200px, var(--sizing-max-content-width, 100%))
        minmax(var(--spacing-container0), 1fr);

      width: 100%;

      background-color: var(--surface-container);
      border-top: 1px solid #000;

      & > * {
        grid-column: 2 / 3;
      }
    }
  </style>
</template>;

export { Player };
