import { buildRegistry } from 'ember-strict-application-resolver/build-registry';

import { buildRoutes } from '#support/routing';

import DetailsRoute from './-routes/details';
import IndexRoute from './-routes/index';
import RootRoute from './-routes/root';

export type { Course } from './-types';

/**
 * @internal
 */
export const CoursesManifest = {
  buildRegistry: buildRegistry({
    './routes/courses': RootRoute,
    './routes/courses/index': IndexRoute,
    './routes/courses/details': DetailsRoute
  }),
  buildRoutes: buildRoutes(function () {
    /* eslint-disable @typescript-eslint/no-invalid-this, unicorn/no-this-outside-of-class */
    this.route('courses', function () {
      this.route('details', { path: '/:id' });
    });
    /* eslint-enable @typescript-eslint/no-invalid-this, unicorn/no-this-outside-of-class */
  })
};
