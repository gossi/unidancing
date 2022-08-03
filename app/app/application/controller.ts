import Controller from '@ember/controller';
import { service, Registry as Services } from '@ember/service';
import { action } from '@ember/object';
import { Game } from '../games/games';

export default class ApplicationController extends Controller {
  @service declare spotify: Services['spotify'];
  @service declare games: Services['games'];

  @action
  openGame(game: Game) {
    this.games.openGame(game);
  }
}
