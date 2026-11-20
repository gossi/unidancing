import { isReadyForPlayback } from '../abilities';
import { SpotifyPlayerWarning } from './spotify-player-warning';

export const MaybeSpotifyPlayerWarning = <template>
  {{#unless (isReadyForPlayback)}}
    <SpotifyPlayerWarning />
  {{/unless}}
</template>;
