import { pageTitle } from 'ember-page-title';
import { service } from '@ember/service';
import { link } from 'ember-link';
import { on } from '@ember/modifier';

import { Game } from '../../../games/games';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import type { LinkManagerService } from 'ember-link';
import type RouterService from '@ember/routing/router-service';

export class TrainingPlanningGamesRoute extends Route<{}> {
  @service declare linkManager: LinkManagerService;
  @service('router') declare emberRouter: RouterService;

  buildGameLink = (game: Game) => {
    return this.linkManager.createLink({
      route: this.emberRouter.currentRouteName as string,
      query: {
        game
      }
    });
  };

  <template>
    {{pageTitle "Assistenten"}}

    <h1>Hilfsmittel</h1>

    <ul>
      {{#let (this.buildGameLink Game.DanceMix) as |link|}}
        <li>
          <a href={{link.url}} {{on 'click' link.open}}>Dance Mix</a><br>
          Super Mix zum Freestylen. Einmal anschalten und die Jukebox geht los.
          Wechselt den Song für genügend Abwechselung. Super Training für die
          ganze Gruppe.
        </li>
      {{/let}}

      {{#let (link 'games' Game.Loops) as |link|}}
        <li>
          <a href={{link.url}} {{on 'click' link.transitionTo}}>Loops</a><br>
          Die gleiche Sequenz von einem Lied? Immer und immer wieder? Genau das
          sind Loops, ideal zum einstudieren von kurzen Choreos.
        </li>
      {{/let}}
    </ul>
  </template>
}

export default CompatRoute(TrainingPlanningGamesRoute);
