import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { Player } from '../player/player';

export default class PlayerService extends Service implements Player {
  @tracked player?: Player;

  toggle() {
    this.player?.toggle();
  }
}

declare module '@ember/service' {
  interface Registry {
    player: PlayerService;
  }
}
