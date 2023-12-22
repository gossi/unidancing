import RouteTemplate from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import { load } from 'ember-async-data';
import { MoveDetails } from '../-components';
import { findMove } from '../resource';

interface Signature {
  Args: {
    model: {
      id: string;
    }
  }
}

export default RouteTemplate<Signature>(<template>
  {{#let (load (findMove @model.id)) as |r|}}
    {{#if r.isResolved}}
      {{pageTitle r.value.title}}

      <MoveDetails @move={{r.value}} />
    {{/if}}
  {{/let}}
</template>);
