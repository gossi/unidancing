import IconDesktop from '~icons/ph/desktop';
import IconDeviceMobile from '~icons/ph/device-mobile';
import IconSpeakerHifi from '~icons/ph/speaker-hifi';
import IconTelevisionSimple from '~icons/ph/television-simple';

export function formatArtists(artists: SpotifyApi.ArtistObjectSimplified[]) {
  return artists.map((artist) => artist.name).join(', ');
}

const deviceMap = {
  computer: IconDesktop,
  tv: IconTelevisionSimple,
  smartphone: IconDeviceMobile,
  speaker: IconSpeakerHifi
} as const;

type DeviceIcon = (typeof deviceMap)[keyof typeof deviceMap];

export function device2Icon(
  device: string extends 'Computer' | 'TV' | 'Smartphone' | 'Speaker'
    ? 'Computer' | 'TV' | 'Smartphone' | 'Speaker'
    : string
): DeviceIcon {
  return deviceMap[device.toLowerCase() as keyof typeof deviceMap];
}
