import { LinkTo } from '@ember/routing';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import { CardSection, Features } from '../../../supporting/ui';

export class TrainingIndexRoute extends Route<object> {
  <template>
    <p>
      Materialien und Informationen zur Trainingsgestaltung und -auswertung.
    </p>

    <Features>
      <CardSection>
        <:header><h2><LinkTo @route="training.planning">Planung</LinkTo></h2></:header>
        <:body>
          Trainingsgestaltung und Trainingspläne.
        </:body>
      </CardSection>

      <CardSection>
        <:header><h2><LinkTo @route="training.control">Steuerung</LinkTo></h2></:header>
        <:body>
          Steuergrößen für das Kür-Training.
        </:body>
      </CardSection>

      <CardSection>
        <:header><h2><LinkTo @route="training.diagnostics">Diagnostik</LinkTo></h2></:header>
        <:body>
          Kenngrößen und -werte für die Trainingsanalyse von Küren.
        </:body>
      </CardSection>
    </Features>
  </template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(TrainingIndexRoute);
