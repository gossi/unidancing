import Component from '@glimmer/component';
import { service, Registry as Services } from '@ember/service';
import {Game} from '../games/games';
import DanceMix from '../games/dance-mix';
import styles from './game.css';
import { on } from '@ember/modifier';
import {action} from '@ember/object';

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
  @service declare games: Services['games'];

  private get gameByArg() {
    return findGame(this.args.game);
  }

  private get gameByService() {
    return findGame(this.games.game);
  }

  get Game() {
    if (this.gameByArg) {
      return this.gameByArg;
    }

    if (this.gameByService) {
      return this.gameByService;
    }

    return undefined;
  }

  @action
  close() {
    this.games.close();
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
