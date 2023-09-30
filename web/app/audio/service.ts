import { tracked } from '@glimmer/tracking';
import Service from '@ember/service';

export enum AudioPlayer {
  Spotify = 'spotify'
}

export class AudioService extends Service {
  @tracked player?: AudioPlayer;
}

declare module '@ember/service' {
  interface Registry {
    player: AudioService;
  }
}
