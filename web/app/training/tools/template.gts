import RouteTemplate from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import { link } from 'ember-link';
import { on } from '@ember/modifier';

import type ToolsController from './controller';

interface Signature {
  Args: {
    controller: ToolsController;
  };
}

export default RouteTemplate<Signature>(<template>
  {{pageTitle "Hilfsmittel"}}
  <h1>Hilfsmittel</h1>

  <ul>
    {{#let (@controller.buildGameLink @controller.Game.DanceMix) as |link|}}
      <li>
        <a href={{link.url}} {{on 'click' link.transitionTo}}>Dance Mix</a><br>
        Super Mix zum Freestylen. Einmal anschalten und die Jukebox geht los.
        Wechselt den Song für genügend Abwechselung. Super Training für die
        ganze Gruppe.
      </li>
    {{/let}}

    {{#let (link 'games' @controller.Game.Loops) as |link|}}
      <li>
        <a href={{link.url}} {{on 'click' link.transitionTo}}>Loops</a><br>
        Die gleiche Sequenz von einem Lied? Immer und immer wieder? Genau das
        sind Loops, ideal zum einstudieren von kurzen Choreos.
      </li>
    {{/let}}
  </ul>
</template>);
