import RouteTemplate from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import { link } from 'ember-link';
import Teaser from '../-components/teaser';

import type { Move } from '../../database/moves';

interface Signature {
  Args: {
    model: Move[];
  };
}

export default RouteTemplate<Signature>(<template>
  {{pageTitle 'Moves'}}

  <h1>Moves</h1>

  <p>Spezielle Auswahl von Bewegungen und Körpertechniken für Einradfahrer, die deiner Kür Charakter verleihen.</p>

  {{#each @model as |entry|}}
    <Teaser @move={{entry}} @link={{link 'moves.details' entry.id}} />
  {{/each}}
</template>);
