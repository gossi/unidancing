import RouteTemplate from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import { link } from 'ember-link';
import { LinkTo } from '@ember/routing';
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

  <p>Zum Lernen von <LinkTo @route="moves">Moves</LinkTo> und Körperkunst.</p>

  {{#each @model as |entry|}}
    <Teaser
      @exercise={{entry}}
      @link={{link 'exercises.details' entry.id}}
    />
  {{/each}}
</template>);
