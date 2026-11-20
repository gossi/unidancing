import { buildRegistry } from 'ember-strict-application-resolver/build-registry';

import HomeRoute from './routes/home';

/**
 * Home renders on the implicit `index` route, so there is no router DSL to
 * contribute. The registry entry is looked up when `/` is entered.
 *
 * @internal
 */
export const HomeManifest = {
  buildRegistry: buildRegistry({
    './routes/index': HomeRoute
  })
};
