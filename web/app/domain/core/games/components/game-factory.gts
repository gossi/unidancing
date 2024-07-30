import Component from '@glimmer/component';

import { findGame } from '../games';

import type {Game } from '../games';

export interface GameSignature {
  Args: {
    game?: Game;
  };
}

export class GameFactory extends Component<GameSignature> {
  get Game() {
    return findGame(this.args.game);
  }

  <template>
    {{#if this.Game}}
      <this.Game />
    {{/if}}
  </template>
}
