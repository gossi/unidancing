import RouteTemplate from 'ember-route-template';
import { LinkTo } from '@ember/routing';

export default RouteTemplate(<template>
  <h1>UniDancing</h1>

  <p>Zentrale Anlaufstelle für <b>UniDancing</b>. Hier finden sich:</p>

  <ul>
    <li><LinkTo @route="skills">Artistische Fertigkeiten</LinkTo></li>
    <li><LinkTo @route="exercises">Übungen</LinkTo>
      zur eigenen Trainingsgestaltung</li>
    <li>Interaktive Spiele zur Durchführung der Übungen</li>
    <li><LinkTo @route="choreography">Choreographie</LinkTo> Hub</li>
  </ul>
</template>);