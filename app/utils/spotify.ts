export function formatArtists(artists: SpotifyApi.TrackObjectFull[]) {
  return artists.map((artist) => artist.name).join(', ');
}
