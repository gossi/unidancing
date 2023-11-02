import RouteTemplate from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import { link } from 'ember-link';
import Teaser from '../-components/teaser';

import type { Exercise } from '../../database/exercises';

interface Signature {
  Args: {
    model: Exercise[];
  }
}

export default RouteTemplate<Signature>(<template>
  {{pageTitle 'Übungen'}}

  <h1>Übungen</h1>

  {{#each @model as |entry|}}
    <Teaser
      @exercise={{entry}}
      @link={{link 'exercises.details' entry.id}}
    />
  {{/each}}
</template>);
