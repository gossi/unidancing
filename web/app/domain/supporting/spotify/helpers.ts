// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import type { Icons } from '../ui';

export function formatArtists(artists: SpotifyApi.ArtistObjectSimplified[]) {
  return artists.map((artist) => artist.name).join(', ');
}

export function device2Icon(device: string | 'Computer' | 'TV' | 'Smartphone' | 'Speaker') {
  return device.toLowerCase() as Icons;
}
