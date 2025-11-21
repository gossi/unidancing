import { resource, resourceFactory } from 'ember-resources';
import { sweetenOwner } from 'ember-sweet-owner';

import { Game } from './games';

import type { GameParams } from './games';
import type { Link, LinkManagerService } from 'ember-link';

export type GameLinkBuilder<P extends keyof GameParams> = (game: P, params?: GameParams[P]) => Link;

export const buildGameLink = resourceFactory(
  <P extends keyof GameParams>(game: Game, params?: GameParams[P]) => {
    return resource(({ owner }) => {
      const { services } = sweetenOwner(owner);
      const { linkManager, router } = services;

      if (game === Game.Bingo) {
        return (linkManager as LinkManagerService).createLink({
          route: 'games',
          models: ['bingo']
        });
      }

      if (game === Game.WheelOfDance) {
        return (linkManager as LinkManagerService).createLink({
          route: 'games',
          models: [Game.WheelOfDance]
        });
      }

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
