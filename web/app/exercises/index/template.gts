import RouteTemplate from 'ember-route-template';
import { LinkTo } from '@ember/routing';
import { load } from 'ember-async-data';
import { ExerciseTeaser } from '../-components';
import { findExercises } from '../resource';

export default RouteTemplate(<template>
  <h1>Übungen</h1>

  <p>Zum Lernen von <LinkTo @route="moves">Moves</LinkTo> und <LinkTo @route="arts">Körperkünsten</LinkTo>.</p>

  {{#let (load (findExercises)) as |r|}}
    {{#if r.isResolved}}
      {{#each r.value as |exercise|}}
        <ExerciseTeaser @exercise={{exercise}} />
      {{/each}}
    {{/if}}
  {{/let}}
</template>);
