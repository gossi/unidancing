import type { Icons } from '../../components/icon';

export function formatArtists(artists: SpotifyApi.ArtistObjectSimplified[]) {
  return artists.map((artist) => artist.name).join(', ');
}

export function device2Icon(device: string | 'Computer' | 'TV' | 'Smartphone' | 'Speaker') {
  return device.toLowerCase() as Icons;
}
