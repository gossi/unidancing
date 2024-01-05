import { pageTitle } from 'ember-page-title';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

export class TrainingPlanningRoute extends Route<{}> {
  <template>
    {{pageTitle "Planung"}}

    {{outlet}}
  </template>
}

export default CompatRoute(TrainingPlanningRoute);
