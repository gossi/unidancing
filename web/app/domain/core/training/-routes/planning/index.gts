import { LinkTo } from '@ember/routing';
import { Features } from '../../../../supporting/ui';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

export class TrainingPlanningIndexRoute extends Route<{}> {
  <template>
    <h2>Trainingsplanung</h2>

    <p>Trainingsgestaltung und Trainingspläne.</p>

    <p>Zur Trainingsgestaltung bieten sich die zahlreichen <LinkTo
    @route="exercises">Übungen</LinkTo> und die fertigen <LinkTo
    @route="courses">Kurse</LinkTo> an.</p>

    <Features as |f|>
      <ul class={{f.list}}>
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
  </template>
}

export default CompatRoute(TrainingPlanningIndexRoute);
