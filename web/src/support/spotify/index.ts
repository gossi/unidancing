export { SpotifyClient } from './client';
export { SpotifyService } from './service';

// routes
export { SpotifyAuthRoute } from './routes/auth';

// components
export { LoginWithSpotify } from './components/login-with-spotify.gts';
export { MaybeSpotifyPlayerWarning } from './components/maybe-spotify-player-warning.gts';
export { PlayTrack } from './components/play-track.gts';
export { SpotifyPlayer } from './components/player.gts';
export { PlaylistChooser } from './components/playlist-chooser.gts';
export { SpotifyPlayButton } from './components/spotify-play-button.gts';
export { SpotifyPlayerWarning } from './components/spotify-player-warning.gts';
export { WithSpotify } from './components/with-spotify.gts';

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
