import { pageTitle } from 'ember-page-title';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

export class TrainingControlRoute extends Route<{}> {
  <template>
    {{pageTitle "Trainingssteuerung"}}

    <h2>Trainingssteuerung</h2>

    tbd.
  </template>
}

export default CompatRoute(TrainingControlRoute);
