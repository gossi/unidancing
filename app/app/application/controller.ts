import Controller from '@ember/controller';
import { service, Registry as Services } from '@ember/service';
import { action } from '@ember/object';
import { Game } from '../games/games';
import { tracked } from '@glimmer/tracking';
import { ALL_GAME_PARAMS } from '../games/games';
import { set } from '@ember/object';

export default class ApplicationController extends Controller {
  @service declare spotify: Services['spotify'];
  @service declare games: Services['games'];
  @service declare linkManager: Services['link-manager'];
  @service declare router: Services['router'];

  Game = Game;

  queryParams = ['game', ...ALL_GAME_PARAMS];

  @tracked game?: Game;

  @action
  openGame(game: Game) {
    this.games.open(game);
  }

  @action
  close() {
    this.game = undefined;

    for (const param of ALL_GAME_PARAMS) {
      // eslint-disable-next-line @typescript-eslint/ban-ts-comment
      // @ts-ignore
      set(this, param, undefined);
    }
  }

  linkFor = (game: Game) => {
    return this.linkManager.createUILink({
      route: this.router.currentRouteName,
      query: {
        game
      }
    });
  };
}
