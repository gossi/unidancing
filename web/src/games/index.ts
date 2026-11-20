import { buildRegistry } from 'ember-strict-application-resolver/build-registry';

import { buildRoutes } from '#support/routing';

import GamesRoute from './routes/games';

export { GameFactory } from './components/game-factory';
export type { AllGameParams, GameParams } from './games';
export { ALL_GAME_PARAMS, Game } from './games';
export type { GameLinkBuilder } from './resources';
export { buildGameLink } from './resources';

/**
 * @internal
 */
export const GamesManifest = {
  buildRegistry: buildRegistry({
    './routes/games': GamesRoute
  }),
  buildRoutes: buildRoutes(function () {
    /* eslint-disable @typescript-eslint/no-invalid-this, unicorn/no-this-outside-of-class */
    this.route('games', { path: '/games/:game' });
    /* eslint-enable @typescript-eslint/no-invalid-this, unicorn/no-this-outside-of-class */
  })
};
