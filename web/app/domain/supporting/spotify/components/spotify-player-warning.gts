import { Icon } from '@hokulea/ember';

import styles from './spotify-player-warning.module.css';

export const SpotifyPlayerWarning = <template>
  <p>
    <Icon @icon="warning" @style="fill" class={{styles.warning}} />
    Bitte Spotify Player auswählen
  </p>
</template>;
