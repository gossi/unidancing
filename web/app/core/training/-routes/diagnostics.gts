import { pageTitle } from 'ember-page-title';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

export class TrainingDiagnosticsRoute extends Route<{}> {
  <template>
    {{pageTitle "Diagnostik"}}

    {{outlet}}
  </template>
}

export default CompatRoute(TrainingDiagnosticsRoute);
