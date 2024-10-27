export function formatArtists(artists: SpotifyApi.ArtistObjectSimplified[]) {
  return artists.map((artist) => artist.name).join(', ');
}

const deviceMap = {
  computer: 'desktop',
  tv: 'television-simple',
  smartphone: 'device-mobile',
  speaker: 'speaker-hifi'
} as const;

type DeviceIcon = (typeof deviceMap)[keyof typeof deviceMap];

export function device2Icon(
  device: string extends 'Computer' | 'TV' | 'Smartphone' | 'Speaker'
    ? 'Computer' | 'TV' | 'Smartphone' | 'Speaker'
    : string
): DeviceIcon {
  return deviceMap[device.toLowerCase() as keyof typeof deviceMap] as DeviceIcon;
}
