import { tracked } from '@glimmer/tracking';
import Service from '@ember/service';

import { SoundBoard } from './soundboard';

export enum AudioPlayer {
  Spotify = 'spotify'
}

export class AudioService extends Service {
  @tracked player?: AudioPlayer;

  soundboard: SoundBoard = new SoundBoard();
}

declare module '@ember/service' {
  interface Registry {
    player: AudioService;
  }
}
