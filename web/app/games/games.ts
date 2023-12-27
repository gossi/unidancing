import { resource, resourceFactory } from 'ember-resources';
import { sweetenOwner } from 'ember-sweet-owner';

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import Bingo from './bingo';
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import DanceMix, { DanceMixParam } from './dance-mix';
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import DanceOhMat from './dance-oh-mat';
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import Looper from './looper';

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import type { DanceMixParams } from './dance-mix';
import type { Link, LinkManagerService } from 'ember-link';

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

export type GameLinkBuilder<K extends keyof Games> = (game: K, params?: Games[K]) => Link;

export const buildGameLink = resourceFactory(
  <K extends keyof Games>(game: K, params?: Games[K]) => {
    return resource(({ owner }) => {
      const { services } = sweetenOwner(owner);
      const { linkManager, router } = services;

      return (linkManager as LinkManagerService).createLink({
        route: router.currentRouteName as string,
        query: {
          game,
          ...params
        }
      });
    });
  }
);

export type AllGameParams = DanceMixParams;

export const ALL_GAME_PARAMS = [...Object.values(DanceMixParam)];

export interface Games {
  'dance-mix': DanceMixParams;
}

export type GameKey = keyof Games;
