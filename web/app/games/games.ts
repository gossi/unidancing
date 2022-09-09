import DanceMix, { DanceMixParam, DanceMixParams } from './dance-mix';
import Bingo from './bingo';

export function findGame(game?: Game) {
  switch (game) {
    case Game.DanceMix:
      return DanceMix;

    case Game.Bingo:
      return Bingo;
  }

  return undefined;
}

export enum Game {
  DanceMix = 'dance-mix',
  Bingo = 'bingo'
}

export const ALL_GAME_PARAMS = [...Object.values(DanceMixParam)];

export interface Games {
  'dance-mix': DanceMixParams;
}
