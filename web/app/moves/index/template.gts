import RouteTemplate from 'ember-route-template';
import { load } from 'ember-async-data';
import { MoveTeaser } from '../-components';
import { pageTitle } from 'ember-page-title';
import { findMoves } from '../resource';

export default RouteTemplate(<template>
  {{pageTitle 'Moves'}}

  <h1>Moves</h1>

  <p>Spezielle Auswahl von Bewegungen und Körpertechniken für Einradfahrer, die
  deiner Kür Charakter verleihen.</p>

  {{#let (load (findMoves)) as |r|}}
    {{#if r.isResolved}}
      {{#each r.value as |move|}}
        <MoveTeaser @move={{move}} />
      {{/each}}
    {{/if}}
  {{/let}}
</template>);
