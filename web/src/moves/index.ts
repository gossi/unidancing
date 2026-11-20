import { buildRegistry } from 'ember-strict-application-resolver/build-registry';

import { buildRoutes } from '#support/routing';

import DetailsRoute from './-routes/details';
import IndexRoute from './-routes/index';
import RootRoute from './-routes/root';

export { MoveDetails } from './-components';
export type { Move } from './-types';

/**
 * @internal
 */
export const MovesManifest = {
  buildRegistry: buildRegistry({
    './routes/moves': RootRoute,
    './routes/moves/index': IndexRoute,
    './routes/moves/details': DetailsRoute
  }),
  buildRoutes: buildRoutes(function () {
    /* eslint-disable @typescript-eslint/no-invalid-this, unicorn/no-this-outside-of-class */
    this.route('moves', function () {
      this.route('details', { path: '/:id' });
    });
    /* eslint-enable @typescript-eslint/no-invalid-this, unicorn/no-this-outside-of-class */
  })
};
