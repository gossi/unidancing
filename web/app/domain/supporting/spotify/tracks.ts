import { action } from 'ember-command';

import { SpotifyService } from './service';

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

function randomNumber(min: number, max: number) {
  return Math.random() * (max - min) + min;
}

export function getStartForDancing(track: Track, expectedDuration?: number) {
  const duration =
    expectedDuration ?? (track.duration_ms - track.duration_ms * randomNumber(30, 40)) / 1000;
  const offset = randomNumber(15, 50) / 100;
  const preferredStart = track.duration_ms * offset;
  const minStart = track.duration_ms - duration * 1000;
  const effectiveStart = Math.min(preferredStart, minStart);
  const start = Math.max(0, effectiveStart);

  return start;
}

export const playTrackForDancing = action(
  ({ service }) =>
    async (track: Track, expectedDuration?: number) => {
      const start = getStartForDancing(track, expectedDuration);

      const client = service(SpotifyService).client;

      await client.play({
        uris: [track.uri],
        // eslint-disable-next-line @typescript-eslint/naming-convention
        position_ms: start
      });
    }
);

export const playTrack = action(({ service }) => async (track: Track, start?: number) => {
  const client = service(SpotifyService).client;

  await client.play({
    uris: [track.uri],
    // eslint-disable-next-line @typescript-eslint/naming-convention
    position_ms: start ?? 0
  });
});
