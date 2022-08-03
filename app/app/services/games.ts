import Service from '@ember/service';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';
import { Game } from '../games/games';

export default class GamesService extends Service {
  @tracked game?: Game;

  @action
  openGame(game: Game) {
    this.game = game;
  }
}

declare module '@ember/service' {
  interface Registry {
    games: GamesService;
  }
}
