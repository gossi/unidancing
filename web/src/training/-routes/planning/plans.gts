import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import { Page } from '@hokulea/ember';

export class TrainingPlanningPlansRoute extends Route<object> {
  <template>
    <Page @title="Trainingspläne">
      rr
    </Page>
  </template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(TrainingPlanningPlansRoute);
