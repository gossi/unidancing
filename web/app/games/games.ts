import Bingo from './bingo';
import DanceMix, { DanceMixParam } from './dance-mix';

import type { DanceMixParams } from './dance-mix';

export enum Game {
  DanceMix = 'dance-mix',
  Bingo = 'bingo'
}

export function findGame(game?: Game) {
  switch (game) {
    case Game.DanceMix:
      return DanceMix;

    case Game.Bingo:
      return Bingo;
  }

  return undefined;
}

export const ALL_GAME_PARAMS = [...Object.values(DanceMixParam)];

export interface Games {
  'dance-mix': DanceMixParams;
}
