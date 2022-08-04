import Component from '@glimmer/component';
import { Game, findGame } from '../games/games';

export interface GameSignature {
  Args: {
    game?: Game;
  }
}

export default class GameComponent extends Component<GameSignature> {
  get Game() {
    return findGame(this.args.game);
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
