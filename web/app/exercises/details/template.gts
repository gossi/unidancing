import RouteTemplate from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import { load } from 'ember-async-data';
import { ExerciseDetails } from '../-components';
import { findExercise } from '../resource';

interface Signature {
  Args: {
    model: {
      id: string;
    }
  }
}

export default RouteTemplate<Signature>(<template>
  {{#let (load (findExercise @model.id)) as |r|}}
    {{#if r.isResolved}}
      {{pageTitle r.value.title}}

      <ExerciseDetails @exercise={{r.value}} />
    {{/if}}
  {{/let}}
</template>);
