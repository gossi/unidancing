// @ts-ignore
import { SpotifyService } from '../domain/supporting/spotify';

export default SpotifyService;

declare module '@ember/service' {
  interface Registry {
    spotify: SpotifyService;
  }
}
