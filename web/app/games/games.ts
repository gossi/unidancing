import Bingo from './bingo';
import DanceMix, { DanceMixParam } from './dance-mix';
import DanceOhMat from './dance-oh-mat';
import Looper from './looper';

import type { DanceMixParams } from './dance-mix';

export enum Game {
  DanceMix = 'dance-mix',
  Bingo = 'bingo',
  Loops = 'loops',
  DanceOhMat = 'dance-oh-mat'
}

export function findGame(game?: Game) {
  switch (game) {
    case Game.DanceMix:
      return DanceMix;

    case Game.Bingo:
      return Bingo;

    case Game.Loops:
      return Looper;

    case Game.DanceOhMat:
      return DanceOhMat;
  }

  return undefined;
}

export const ALL_GAME_PARAMS = [...Object.values(DanceMixParam)];

export interface Games {
  'dance-mix': DanceMixParams;
}

export type GameKey = keyof Games;
