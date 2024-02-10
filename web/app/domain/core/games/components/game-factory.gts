import Component from '@glimmer/component';
import { Game, findGame } from '../games';

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
