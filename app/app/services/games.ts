import Service from '@ember/service';
import { action } from '@ember/object';
// import { tracked } from '@glimmer/tracking';
import { Game } from '../games/games';
import { queryParam } from 'ember-query-params-service';
import { service, Registry as Services } from '@ember/service';
import { inject as controller } from '@ember/controller';
import ApplicationController from '../application/controller';

export default class GamesService extends Service {
  @service declare queryParams: Services['query-params'];
  @controller declare application: ApplicationController;
  // @tracked game?: Game;

  // @queryParam game?: Game;
  get game() {
    return this.application.game;
  }

  @action
  open(game: Game) {
    // this.game = game;
  }

  @action
  close() {
    // this.game = undefined;
    this.application.game = undefined;
  }
}

declare module '@ember/service' {
  interface Registry {
    games: GamesService;
  }
}
