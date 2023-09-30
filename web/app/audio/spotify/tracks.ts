function randomItem<T>(items: T[]) {
  return items[Math.floor(Math.random() * items.length)];
}

export function getRandomTracks(
  list: SpotifyApi.TrackObjectFull[],
  amount = 5
): SpotifyApi.TrackObjectFull[] {
  const tracks: SpotifyApi.TrackObjectFull[] = [];

  while (tracks.length < amount) {
    const track = randomItem<SpotifyApi.TrackObjectFull>(list);

    if (!tracks.includes(track)) {
      tracks.push(track);
    }
  }

  return tracks;
}
