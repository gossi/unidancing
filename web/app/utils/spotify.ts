export function formatArtists(artists: SpotifyApi.ArtistObjectSimplified[]) {
  return artists.map((artist) => artist.name).join(', ');
}
