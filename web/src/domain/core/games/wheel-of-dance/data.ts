export const DanceStyles = ['Waacking', 'Popping', 'Tutting', 'Locking', 'Arms'] as const;

export type DanceStyle = (typeof DanceStyles)[number];

export function asDanceStyles(strings: string[] | undefined): DanceStyle[] {
  return strings as DanceStyle[];
}

export const Playlists = {
  Funk: '0wEfILxvKdm3u69ZyR8a1e',
  Rock: '24biZmTHT60trCUooVg1Dx',
  Disco: '3sRWuoQV6MeTqKNXtGtwbB',
  Surprise: '7FDu1kevbWvjA2dC9KNkWW',
  Klassik: '7qObzZ1HOB9ClJaCK4MLiE',
  'Hip-Hop': '5g8s9ZTMH1nTXa1P9oAQgC',
  'K-Pop': '6MJ449uFD7efWGjm551VRH',
  Epic: '67lqL0lRDAtM4w55tZgsXV',
  Eurodance: '2ADlxkSWluAYNfiHc13pmj',
  'Irish Folk': '4j50k7Y22R2x2qBmS4ZJLz',
  Country: '6xAzCQ7mMiN7r5nNSpi54a'
};

export type Context = {
  duration: number;
  preparation: number;
  styles: DanceStyle[];
};

export function asContext(strings: Partial<Context> | undefined): Context {
  return strings as Context;
}

export const Genres = Object.keys(Playlists);

export type Genre = keyof typeof Playlists;

export const WheelOfFortuneDefaults = {
  duration: 35,
  preparation: 5,
  styles: DanceStyles as unknown as DanceStyle[]
};
