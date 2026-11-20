import { buildRegistry } from 'ember-strict-application-resolver/build-registry';

import { buildRoutes } from '#support/routing';

import { SpotifyAuthRoute } from './routes/auth';

export { SpotifyClient } from './client';
export { SpotifyService } from './service';

// components
export { LoginWithSpotify } from './components/login-with-spotify';
export { MaybeSpotifyPlayerWarning } from './components/maybe-spotify-player-warning';
export { PlayTrack } from './components/play-track';
export { SpotifyPlayer } from './components/player';
export { PlaylistChooser } from './components/playlist-chooser';
export { SpotifyPlayButton } from './components/spotify-play-button';
export { SpotifyPlayerWarning } from './components/spotify-player-warning';
export { WithSpotify } from './components/with-spotify';

// resources
export { getTracks, loadPlaylist } from './resources/playlist';
export { loadPlaylists } from './resources/playlists';
export { findTrack } from './resources/track';

// helpers
export { formatArtists } from './helpers';

// music
export * from './abilities';
export * from './domain-objects';
export {
  getRandomTrack,
  getRandomTracks,
  getStartForDancing,
  playTrack,
  playTrackForDancing
} from './tracks';

/**
 * @internal
 */
export const SpotifyManifest = {
  buildRegistry: buildRegistry({
    './routes/auth/spotify': SpotifyAuthRoute
  }),
  buildRoutes: buildRoutes(function () {
    /* eslint-disable @typescript-eslint/no-invalid-this, unicorn/no-this-outside-of-class */
    this.route('auth', function () {
      this.route('spotify');
    });
    /* eslint-enable @typescript-eslint/no-invalid-this, unicorn/no-this-outside-of-class */
  })
};
