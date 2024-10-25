import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import { Page } from '@hokulea/ember';

export class TrainingControlRoute extends Route<object> {
  <template>
    {{pageTitle "Trainingssteuerung"}}

    <Page @title="Trainingssteuerung">
      tbd.
    </Page>
  </template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(TrainingControlRoute);
