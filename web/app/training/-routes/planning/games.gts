import { pageTitle } from 'ember-page-title';
import { service } from '@ember/service';
import { link } from 'ember-link';
import { on } from '@ember/modifier';
import { LinkTo } from '@ember/routing';

import { Game } from '../../../games/games';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import type { LinkManagerService } from 'ember-link';
import type RouterService from '@ember/routing/router-service';

export class TrainingPlanningGamesRoute extends Route<{}> {
  @service declare linkManager: LinkManagerService;
  @service declare router: RouterService;

  Game = Game;

  buildGameLink = (game: Game) => {
    return this.linkManager.createLink({
      route: this.router.currentRouteName as string,
      query: {
        game
      }
    });
  };

  <template>
    {{pageTitle "Spiele"}}

    <h1>Spiele</h1>

    <ul>
      {{#let (link 'games' Game.Bingo) as |link|}}
        <li>
          <a href={{link.url}} {{on 'click' link.transitionTo}}>Bingo</a><br>
          Spielerische Sensibilisierung für Aspekte, die man besser <LinkTo @route="choreography.not-todo-list"><i>nicht
          macht</i> in einer Kür</LinkTo>.
        </li>
      {{/let}}
    </ul>
  </template>
}

export default CompatRoute(TrainingPlanningGamesRoute);
