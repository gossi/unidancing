import { SpotifyService } from '@unidancing/spotify';

export default SpotifyService;

declare module '@ember/service' {
  interface Registry {
    spotify: SpotifyService;
  }
}
