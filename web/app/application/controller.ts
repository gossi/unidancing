import Controller from '@ember/controller';
import { service, Registry as Services } from '@ember/service';
import { action } from '@ember/object';
import { Game, ALL_GAME_PARAMS } from '../games/games';
import { tracked } from '@glimmer/tracking';
import { set } from '@ember/object';

export default class ApplicationController extends Controller {
  @service declare linkManager: Services['link-manager'];
  @service declare router: Services['router'];

  Game = Game;

  queryParams = ['game', ...ALL_GAME_PARAMS];

  @tracked game?: Game;

  @action
  close() {
    this.game = undefined;

    for (const param of ALL_GAME_PARAMS) {
      // eslint-disable-next-line @typescript-eslint/ban-ts-comment
      // @ts-ignore
      set(this, param, undefined);
    }
  }

  buildGameLink = (game: Game) => {
    return this.linkManager.createUILink({
      route: this.router.currentRouteName,
      query: {
        game
      }
    });
  };
}
