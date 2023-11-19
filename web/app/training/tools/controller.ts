import Controller from '@ember/controller';
import { service } from '@ember/service';

import { Game } from '../../games/games';

import type { Registry as Services } from '@ember/service';
import type { LinkManagerService } from 'ember-link';

export default class ToolsController extends Controller {
  @service declare linkManager: LinkManagerService;
  @service declare router: Services['router'];

  Game = Game;

  buildGameLink = (game: Game) => {
    return this.linkManager.createLink({
      route: this.router.currentRouteName as string,
      query: {
        game
      }
    });
  };
}
