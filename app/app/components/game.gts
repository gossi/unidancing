import Component from '@glimmer/component';
import { Game } from '../games/games';
import DanceMix from '../games/dance-mix';

export interface GameSignature {
  Args: {
    game?: Game;
  }
}

function findGame(game?: Game) {
  switch (game) {
    case Game.DanceMix:
      return DanceMix;
  }

  return undefined;
}

export default class GameComponent extends Component<GameSignature> {
  private get gameByArg() {
    return findGame(this.args.game);
  }

  get Game() {
    if (this.gameByArg) {
      return this.gameByArg;
    }

    return undefined;
  }

  <template>
    {{#if this.Game}}
      <this.Game />
    {{/if}}
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Game: typeof GameComponent;
  }
}
