import { SpotifyService } from '../audio/spotify';

export default SpotifyService;

declare module '@ember/service' {
  interface Registry {
    spotify: SpotifyService;
  }
}
