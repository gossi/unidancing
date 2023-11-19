import RouteTemplate from 'ember-route-template';
import { LinkTo } from '@ember/routing';
import Features from '../../components/features';

export default RouteTemplate(<template>
  <p>
    Materialien und Informationen zur Trainingsgestaltung und -auswertung.
  </p>

  <Features as |f|>
    <ul class={{f.list}}>
      <li>
        <LinkTo @route='training.control'>Steuerung</LinkTo><br />
        Steuergrößen für das Kür-Training.
      </li>
      <li>
        <LinkTo @route='training.diagnostics'>Diagnostik</LinkTo><br />
        Kenngrößen und -werte für die Trainingsanalyse von Küren.
      </li>
      <li>
        <LinkTo @route='training.tools'>Hilfsmittel</LinkTo><br />
        Interaktive Werkzeuge zur Trainingsgestaltung und -auswertung.
      </li>
      <li>
        <LinkTo @route='training.games'>Spiele</LinkTo><br />
        Zur spielerischen Gestaltung für das Training.
      </li>
    </ul>
  </Features>
</template>);
