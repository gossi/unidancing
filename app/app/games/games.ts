import DanceMix, { DanceMixParam, DanceMixParams } from './dance-mix';

export function findGame(game?: Game) {
  switch (game) {
    case Game.DanceMix:
      return DanceMix;
  }

  return undefined;
}

export enum Game {
  DanceMix = 'dance-mix'
}

export const ALL_GAME_PARAMS = [...Object.values(DanceMixParam)];

export interface Games {
  'dance-mix': DanceMixParams;
}
