import { LinkTo } from '@ember/routing';
import { Features, CardSection } from '@unidancing/ui';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

export class TrainingIndexRoute extends Route<{}> {
  <template>
    <p>
      Materialien und Informationen zur Trainingsgestaltung und -auswertung.
    </p>

    <Features>
      <CardSection>
        <:header><h2><LinkTo @route='training.planning'>Planung</LinkTo></h2></:header>
        <:body>
          Trainingsgestaltung und Trainingspläne.
        </:body>
      </CardSection>

      <CardSection>
        <:header><h2><LinkTo @route='training.control'>Steuerung</LinkTo></h2></:header>
        <:body>
          Steuergrößen für das Kür-Training.
        </:body>
      </CardSection>

      <CardSection>
        <:header><h2><LinkTo @route='training.diagnostics'>Diagnostik</LinkTo></h2></:header>
        <:body>
          Kenngrößen und -werte für die Trainingsanalyse von Küren.
        </:body>
      </CardSection>
    </Features>
  </template>
}

export default CompatRoute(TrainingIndexRoute);
