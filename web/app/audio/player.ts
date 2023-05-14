import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';

export enum Player {
  Spotify = 'spotify'
}

export class PlayerService extends Service {
  @tracked player?: Player;
}

declare module '@ember/service' {
  interface Registry {
    player: PlayerService;
  }
}
