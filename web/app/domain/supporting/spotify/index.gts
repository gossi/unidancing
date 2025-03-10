export { SpotifyClient } from './client';
export { SpotifyService } from './service';

// routes
export { SpotifyAuthRoute } from './routes/auth';

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
