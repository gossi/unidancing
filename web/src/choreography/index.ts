import { buildRegistry } from 'ember-strict-application-resolver/build-registry';

import { buildRoutes } from '#support/routing';

import IndexRoute from './-routes/index';
import NotTodoListRoute from './-routes/not-todo-list';
import RootRoute from './-routes/root';
import UniDancingWritingRoute from './-routes/unidance-writing';
import RoutinesDetailsRoute from './routines/routes/details';
import RoutinesIndexRoute from './routines/routes/index';
import RoutinesResultsRoute from './routines/routes/results';
import RoutinesRootRoute from './routines/routes/root';
import RoutinesTestRoute from './routines/routes/test';
import RoutineTrainingRoute from './routines/routes/training';
import RoutineTrainingResultsRoute from './routines/routes/training/results';

export type { Awfulpractice } from './awful-practices/domain';
export { findAwfulPractices } from './awful-practices/resources';
export { findRoutine } from './routines/analysis/-resource';
export { TimeTrackingBalanceIndicator } from './routines/analysis/time-tracking/balance-indicator';
export type { TimeAnalysis } from './routines/analysis/time-tracking/domain';
export { TimeTrackingEffectivityIndicator } from './routines/analysis/time-tracking/effectivity-indicator';
export { TimeTrackingSummary } from './routines/analysis/time-tracking/evaluation';

/**
 * @internal
 */
export const ChoreographyManifest = {
  buildRegistry: buildRegistry({
    './routes/choreography': RootRoute,
    './routes/choreography/index': IndexRoute,
    './routes/choreography/not-todo-list': NotTodoListRoute,
    './routes/choreography/unidance-writing': UniDancingWritingRoute,

    './routes/choreography/routines': RoutinesRootRoute,
    './routes/choreography/routines/index': RoutinesIndexRoute,
    './routes/choreography/routines/test': RoutinesTestRoute,
    './routes/choreography/routines/test/index': RoutinesTestRoute,
    './routes/choreography/routines/test_load': RoutinesTestRoute,
    './routes/choreography/routines/results': RoutinesResultsRoute,
    './routes/choreography/routines/training/index': RoutineTrainingRoute,
    './routes/choreography/routines/training/results': RoutineTrainingResultsRoute,
    './routes/choreography/routines/details': RoutinesDetailsRoute
  }),
  buildRoutes: buildRoutes(function () {
    /* eslint-disable @typescript-eslint/no-invalid-this, unicorn/no-this-outside-of-class */
    this.route('choreography', function () {
      this.route('not-todo-list');
      this.route('unidance-writing');
      this.route('routines', function () {
        this.route('test');
        this.route('test_load', { path: '/test/:data' });
        this.route('results', { path: '/results/:data' });
        this.route('training', function () {
          this.route('index', { path: '/:data' });
          this.route('results', { path: '/results/:data' });
        });
        this.route('details', { path: '/*path' });
      });
    });
    /* eslint-enable @typescript-eslint/no-invalid-this, unicorn/no-this-outside-of-class */
  })
};
