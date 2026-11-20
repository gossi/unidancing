import { buildRegistry } from 'ember-strict-application-resolver/build-registry';

import { buildRoutes } from '#support/routing';

import DetailsRoute from './-routes/details';
import IndexRoute from './-routes/index';

export { buildSkillLink } from './-resource';
export type { Skill } from './-types';
export type { Move } from '#moves';
export { MoveDetails } from '#moves';

/**
 * The `skills` parent itself has no route module. Ember's implicit route
 * serves it, only the children need registration.
 *
 * @internal
 */
export const SkillsManifest = {
  buildRegistry: buildRegistry({
    './routes/skills/index': IndexRoute,
    './routes/skills/details': DetailsRoute
  }),
  buildRoutes: buildRoutes(function () {
    /* eslint-disable @typescript-eslint/no-invalid-this, unicorn/no-this-outside-of-class */
    this.route('skills', { path: 'fertigkeiten' }, function () {
      this.route('details', { path: '/:id' });
    });
    /* eslint-enable @typescript-eslint/no-invalid-this, unicorn/no-this-outside-of-class */
  })
};
