import type { TOC } from '@ember/component/template-only';
import styles from './spotify-play-button.css';
import { isReadyForPlayback } from '../abilities';
import { not } from 'ember-truth-helpers';

interface SpotifyPlayButtonSignature {
  Element: HTMLButtonElement;
  Args: {
    playing?: boolean;
  }
  Blocks: { default: [] }
}

const SpotifyPlayButton: TOC<SpotifyPlayButtonSignature> = <template>
  <button
    type="button"
    class={{styles.playbutton}}
    disabled={{(not (isReadyForPlayback))}}
    data-playing={{@playing}}
    ...attributes
  >
    <svg viewBox="0 0 24 24">
      {{#if @playing}}
        <path d="M5.7 3a.7.7 0 0 0-.7.7v16.6a.7.7 0 0 0 .7.7h2.6a.7.7 0 0 0.7-.7V3.7a.7.7 0 0 0-.7-.7H5.7zm10 0a.7.7 0 0 0-.7.7v16.6a.7.7 0 0 0.7.7h2.6a.7.7 0 0 0 .7-.7V3.7a.7.7 0 0 0-.7-.7h-2.6z"></path>
      {{else}}
        <path d="m7.05 3.606 13.49 7.788a.7.7 0 0 1 0 1.212L7.05 20.394A.7.7 0 0 1 6 19.788V4.212a.7.7 0 0 1 1.05-.606z"></path>
      {{/if}}
    </svg>
    {{yield}}
  </button>
</template>

export { SpotifyPlayButton };
