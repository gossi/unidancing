import { action } from 'ember-command';

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

export const playTrack = action(({ services }) => async (track: Track) => {
  const client = services.spotify.client;

  await client.play({
    uris: [track.uri]
  });
});

function randomNumber(min: number, max: number) {
  return Math.random() * (max - min) + min;
}

export const playTrackForDancing = action(
  ({ services }) =>
    async (track: Track, expectedDuration) => {
      const client = services.spotify.client;

      const offset = randomNumber(15, 50) / 100;
      const preferredStart = track.duration_ms * offset;
      const minStart = track.duration_ms - expectedDuration * 1000;
      const effectiveStart = Math.min(preferredStart, minStart);
      const start = Math.max(0, effectiveStart);

      await client.play({
        uris: [track.uri],
        // eslint-disable-next-line @typescript-eslint/naming-convention
        position_ms: start
      });
    }
);
