import IconWarningFill from '~icons/ph/warning-fill';

import { Icon } from '@hokulea/ember';

export const SpotifyPlayerWarning = <template>
  <p>
    <Icon @icon={{IconWarningFill}} class="warning" />
    Bitte Spotify Player auswählen
  </p>
  <style scoped>
    .warning {
      color: var(--indicator-warning-plain-text);
    }
  </style>
</template>;
