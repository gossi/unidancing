import { LinkTo } from '@ember/routing';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import { Page } from '@hokulea/ember';

import { Features } from '../../../../supporting/ui';

export class TrainingPlanningIndexRoute extends Route<object> {
  <template>
    <Page @title="Trainingsplanung">
      <p>Trainingsgestaltung und Trainingspläne.</p>

      <p>Zur Trainingsgestaltung bieten sich die zahlreichen <LinkTo
      @route="exercises">Übungen</LinkTo> und die fertigen <LinkTo
      @route="courses">Kurse</LinkTo> an.</p>

      <Features>
        <ul>
          <li>
            <LinkTo @route='training.planning.assistants'>Hilfsmittel</LinkTo><br />
            Interaktive Werkzeuge zur Trainingsgestaltung und -auswertung.
          </li>
          <li>
            <LinkTo @route='training.planning.games'>Spiele</LinkTo><br />
            Zur spielerischen Gestaltung für das Training.
          </li>
        </ul>
      </Features>
    </Page>
  </template>
}

export default CompatRoute(TrainingPlanningIndexRoute);
