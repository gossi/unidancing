import { LinkTo } from '@ember/routing';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import { Page } from '@hokulea/ember';

import { CardSection, Features } from '../../../../supporting/ui';

export class TrainingPlanningIndexRoute extends Route<object> {
  <template>
    <Page @title="Trainingsplanung">
      <p>Trainingsgestaltung und Trainingspläne.</p>

      <Features>
        {{! <CardSection>
          <:header><h2><LinkTo
                @route="training.planning.plans"
              >Trainingspläne</LinkTo></h2></:header>
          <:body>

            ...
          </:body>
        </CardSection> }}

        <CardSection>
          <:header><h2><LinkTo
                @route="training.planning.units"
              >Trainingsgestaltung</LinkTo></h2></:header>
          <:body>
            Zusammenstellung einer Trainigseinheit.
          </:body>
        </CardSection>
      </Features>
    </Page>
  </template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(TrainingPlanningIndexRoute);
