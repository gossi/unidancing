import { tracked } from '@glimmer/tracking';
import Controller from '@ember/controller';
import { action, set } from '@ember/object';
import { service } from '@ember/service';

import { ALL_GAME_PARAMS, Game } from '../games/games';

import type { Registry as Services } from '@ember/service';
import type { LinkManagerService } from 'ember-link';

export default class ApplicationController extends Controller {
  @service declare spotify: Services['spotify'];
  @service declare linkManager: LinkManagerService;
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
    return this.linkManager.createLink({
      route: this.router.currentRouteName as string,
      query: {
        game
      }
    });
  };
}
