import IconWarningFill from '~icons/ph/warning-fill';

import { Icon } from '@hokulea/ember';

import styles from './spotify-player-warning.module.css';

export const SpotifyPlayerWarning = <template>
  <p>
    <Icon @icon={{IconWarningFill}} class={{styles.warning}} />
    Bitte Spotify Player auswählen
  </p>
</template>;
