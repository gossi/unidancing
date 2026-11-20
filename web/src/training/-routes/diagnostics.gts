import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

export class TrainingDiagnosticsRoute extends Route<object> {
  <template>
    {{pageTitle "Diagnostik"}}

    {{outlet}}
  </template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(TrainingDiagnosticsRoute);
