import Bingo from './bingo/bingo';
import { DanceOhMat, DanceOhMatParam } from './dance-oh-mat/dance-oh-mat';

import type { DanceOhMatParams } from './dance-oh-mat/dance-oh-mat';

export enum Game {
  Bingo = 'bingo',
  DanceOhMat = 'dance-oh-mat'
}

export interface GameParams {
  [Game.DanceOhMat]: DanceOhMatParams;
}

export type AllGameParams = DanceOhMatParams;

export const ALL_GAME_PARAMS = [...Object.values(DanceOhMatParam)];

export function findGame(game?: Game) {
  switch (game) {
    case Game.Bingo:
      return Bingo;

    case Game.DanceOhMat:
      return DanceOhMat;
  }

  return undefined;
}
