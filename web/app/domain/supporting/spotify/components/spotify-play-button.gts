import Component from '@glimmer/component';
import { on } from '@ember/modifier';

import { eq, not } from 'ember-truth-helpers';

import { isReadyForPlayback } from '../abilities';
import styles from './spotify-play-button.css';

interface SpotifyPlayButtonSignature {
  Element: HTMLButtonElement;
  Args: {
    intent?: 'play' | 'pause' | 'stop';
    push?: () => void;
  };
  Blocks: { default: [] };
}

export class SpotifyPlayButton extends Component<SpotifyPlayButtonSignature> {
  push = () => {
    this.args.push?.();
  };

  <template>
    <button
      type="button"
      class={{styles.playbutton}}
      disabled={{not (isReadyForPlayback)}}
      {{on "click" this.push}}
      ...attributes
    >
      <svg viewBox="0 0 24 24">
        {{#if (eq @intent "stop")}}
          <path
            d="M3.7 3C3.51435 3 3.3363 3.07375 3.20503 3.20503C3.07375 3.3363 3 3.51435 3 3.7V12V20.3C3 20.4857 3.07375 20.6637 3.20503 20.795C3.3363 20.9263 3.51435 21 3.7 21L20.3 21C20.4856 21 20.6637 20.9262 20.795 20.795C20.9262 20.6637 21 20.4856 21 20.3L21 12L21 3.7C21 3.51435 20.9262 3.3363 20.795 3.20503C20.6637 3.07375 20.4856 3 20.3 3L3.7 3Z"
          />
        {{else if (eq @intent "pause")}}
          <path
            d="M5.7 3a.7.7 0 0 0-.7.7v16.6a.7.7 0 0 0 .7.7h2.6a.7.7 0 0 0.7-.7V3.7a.7.7 0 0 0-.7-.7H5.7zm10 0a.7.7 0 0 0-.7.7v16.6a.7.7 0 0 0.7.7h2.6a.7.7 0 0 0 .7-.7V3.7a.7.7 0 0 0-.7-.7h-2.6z"
          ></path>
        {{else}}
          <path
            d="m7.05 3.606 13.49 7.788a.7.7 0 0 1 0 1.212L7.05 20.394A.7.7 0 0 1 6 19.788V4.212a.7.7 0 0 1 1.05-.606z"
          ></path>
        {{/if}}
      </svg>
      {{yield}}
    </button>
  </template>
}
