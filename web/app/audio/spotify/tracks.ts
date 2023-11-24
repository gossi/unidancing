import type { Track } from './domain-objects';

function randomItem<T>(items: T[]) {
  return items[Math.floor(Math.random() * items.length)];
}

export function getRandomTracks(list: Track[], amount = 5): Track[] {
  const tracks: Track[] = [];

  while (tracks.length < amount) {
    const track = randomItem<Track>(list);

    if (!tracks.includes(track)) {
      tracks.push(track);
    }
  }

  return tracks;
}

export function getRandomTrack(list: Track[]): Track {
  return getRandomTracks(list, 1)[0];
}
