import RouteTemplate from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import { link } from 'ember-link';
import { on } from '@ember/modifier';
import { LinkTo } from '@ember/routing';

import type GamesController from './controller';

interface Signature {
  Args: {
    controller: GamesController;
  };
}

export default RouteTemplate<Signature>(<template>
  {{pageTitle "Spiele"}}
  <h1>Spiele</h1>

  <ul>
    {{#let (link 'games' @controller.Game.Bingo) as |link|}}
      <li>
        <a href={{link.url}} {{on 'click' link.transitionTo}}>Bingo</a><br>
        Spielerische Sensibilisierung für Aspekte, die man besser <LinkTo @route="choreography.not-todo-list"><i>nicht
        macht</i> in einer Kür</LinkTo>.
      </li>
    {{/let}}
  </ul>
</template>);
