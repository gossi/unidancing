import { on } from '@ember/modifier';
import { LinkTo } from '@ember/routing';

import { link } from 'ember-link';
import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import { Page } from '@hokulea/ember';

import { Game } from '../../../games';

export class TrainingPlanningGamesRoute extends Route<object> {
  <template>
    {{pageTitle "Spiele"}}

    <Page @title="Spiele">
      <ul>
        {{#let (link 'games' Game.Bingo) as |bingoLink|}}
          <li>
            <a href={{bingoLink.url}} {{on 'click' bingoLink.transitionTo}}>Bingo</a><br>
            Spielerische Sensibilisierung für Aspekte, die man besser <LinkTo @route="choreography.not-todo-list"><i>nicht
            macht</i> in einer Kür</LinkTo>.
          </li>
        {{/let}}
      </ul>
    </Page>
  </template>
}

export default CompatRoute(TrainingPlanningGamesRoute);
