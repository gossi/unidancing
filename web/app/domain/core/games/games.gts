import Bingo from './bingo/bingo';
import { DanceOhMat, DanceOhMatParam } from './dance-oh-mat/dance-oh-mat';
import { WheelOfDance } from './wheel-of-dance/wheel-of-dance';

import type { DanceOhMatParams } from './dance-oh-mat/dance-oh-mat';

export enum Game {
  // eslint-disable-next-line @typescript-eslint/no-shadow
  Bingo = 'bingo',
  // eslint-disable-next-line @typescript-eslint/no-shadow
  DanceOhMat = 'dance-oh-mat',
  // eslint-disable-next-line @typescript-eslint/no-shadow
  WheelOfDance = 'wheel-of-dance'
}

export interface GameParams {
  [Game.DanceOhMat]: DanceOhMatParams;
}

export type AllGameParams = DanceOhMatParams;

export const ALL_GAME_PARAMS = Object.values(DanceOhMatParam);

export function findGame(game?: Game) {
  switch (game) {
    case Game.Bingo: {
      return Bingo;
    }

    case Game.DanceOhMat: {
      return DanceOhMat;
    }

    case Game.WheelOfDance: {
      return WheelOfDance;
    }
  }

  return;
}

export function getGameTitle(game: Game) {
  switch (game) {
    case Game.Bingo: {
      return 'Bingo';
    }

    case Game.DanceOhMat: {
      return 'Dance Oh! Mat';
    }

    case Game.WheelOfDance: {
      return 'Wheel of Dance';
    }
  }
}

export function asGame(game: string) {
  return game as Game;
}
