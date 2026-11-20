import { buildRegistry } from 'ember-strict-application-resolver/build-registry';

import { buildRoutes } from '#support/routing';

import DetailsRoute from './-routes/details';
import IndexRoute from './-routes/index';
import RootRoute from './-routes/root';

export { buildArtLink } from './-resource';
export type { Art, Technique } from './-types';

/**
 * @internal
 */
export const ArtsManifest = {
  buildRegistry: buildRegistry({
    './routes/arts': RootRoute,
    './routes/arts/index': IndexRoute,
    './routes/arts/details': DetailsRoute
  }),
  buildRoutes: buildRoutes(function () {
    /* eslint-disable @typescript-eslint/no-invalid-this, unicorn/no-this-outside-of-class */
    this.route('arts', { path: 'kuenste' }, function () {
      this.route('details', { path: '/:id' });
    });
    /* eslint-enable @typescript-eslint/no-invalid-this, unicorn/no-this-outside-of-class */
  })
};
