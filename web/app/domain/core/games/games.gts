import Bingo from './bingo/bingo';
import { DanceOhMat, DanceOhMatParam } from './dance-oh-mat/dance-oh-mat';

import type { DanceOhMatParams } from './dance-oh-mat/dance-oh-mat';

export enum Game {
  // eslint-disable-next-line @typescript-eslint/no-shadow
  Bingo = 'bingo',
  // eslint-disable-next-line @typescript-eslint/no-shadow
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

export function getGameTitle(game: Game) {
  switch (game) {
    case Game.Bingo:
      return 'Bingo';

    case Game.DanceOhMat:
      return 'Dance Oh! Mat';
  }
}

export function asGame(game: string) {
  return game as Game;
}
