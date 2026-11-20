import { buildRegistry } from 'ember-strict-application-resolver/build-registry';

import { buildRoutes } from '#support/routing';

import AthleticProfileRoute from './-routes/athletic-profile';
import ControlRoute from './-routes/control';
import DiagnosticsRoute from './-routes/diagnostics';
import DiagnosticsBodyLanguageRoute from './-routes/diagnostics/body-language';
import DiagnosticsIndexRoute from './-routes/diagnostics/index';
import DiagnosticsTimeTrackingRoute from './-routes/diagnostics/time-tracking';
import IndexRoute from './-routes/index';
import PlanningRoute from './-routes/planning';
import PlanningAssistantsRoute from './-routes/planning/assistants';
import PlanningGamesRoute from './-routes/planning/games';
import PlanningIndexRoute from './-routes/planning/index';
import PlanningPlansRoute from './-routes/planning/plans';
import PlanningUnitsRoute from './-routes/planning/units';
import RootRoute from './-routes/root';

/**
 * @internal
 */
export const TrainingManifest = {
  buildRegistry: buildRegistry({
    './routes/training': RootRoute,
    './routes/training/index': IndexRoute,
    './routes/training/athletic-profile': AthleticProfileRoute,
    './routes/training/control': ControlRoute,

    './routes/training/planning': PlanningRoute,
    './routes/training/planning/index': PlanningIndexRoute,
    './routes/training/planning/units': PlanningUnitsRoute,
    './routes/training/planning/plans': PlanningPlansRoute,
    './routes/training/planning/assistants': PlanningAssistantsRoute,
    './routes/training/planning/games': PlanningGamesRoute,

    './routes/training/diagnostics': DiagnosticsRoute,
    './routes/training/diagnostics/index': DiagnosticsIndexRoute,
    './routes/training/diagnostics/time-tracking': DiagnosticsTimeTrackingRoute,
    './routes/training/diagnostics/body-language': DiagnosticsBodyLanguageRoute
  }),
  buildRoutes: buildRoutes(function () {
    /* eslint-disable @typescript-eslint/no-invalid-this, unicorn/no-this-outside-of-class */
    this.route('training', function () {
      this.route('athletic-profile', { path: '/leistungsprofil' });
      this.route('planning', function () {
        this.route('units');
        this.route('plans');
        this.route('assistants');
        this.route('games');
      });
      this.route('control');
      this.route('diagnostics', function () {
        this.route('time-tracking');
        this.route('body-language');
      });
    });
    /* eslint-enable @typescript-eslint/no-invalid-this, unicorn/no-this-outside-of-class */
  })
};
