export function formatArtists(artists: SpotifyApi.ArtistObjectSimplified[]) {
  return artists.map((artist) => artist.name).join(', ');
}

const deviceMap: Record<string, string> = {
  computer: 'desktop',
  tv: 'television-simple',
  smartphone: 'device-mobile',
  speaker: 'speaker-hifi'
};

export function device2Icon(device: 'Computer' | 'TV' | 'Smartphone' | 'Speaker') {
  return deviceMap[device.toLowerCase()];
}
