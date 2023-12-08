export { SpotifyClient } from './client';
export { default as SpotifyService } from './service';

// components
export { default as LoginWithSpotify } from './components/login-with-spotify';
export { default as SpotifyPlayer } from './components/player';
export { default as PlaylistChooser } from './components/playlist-chooser';
export { default as WithSpotify } from './components/with-spotify';

// resources
export { PlaylistResource } from './resources/playlist';
export { PlaylistsResource } from './resources/playlists';
export { TrackResource } from './resources/track';

// helpers
export { formatArtists } from './helpers';

// music
export * from './abilities';
export * from './domain-objects';
export { getRandomTrack, getRandomTracks, playTrack, playTrackForDancing } from './tracks';
