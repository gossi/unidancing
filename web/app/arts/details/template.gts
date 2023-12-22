import RouteTemplate from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import { load } from 'ember-async-data';
import { findArt } from '../resource';
import { ArtDetails } from '../-components';

interface Signature {
  Args: {
    model: {
      id: string;
    }
  }
}

export default RouteTemplate<Signature>(<template>
  {{#let (load (findArt @model.id)) as |r|}}
    {{#if r.isResolved}}
      {{pageTitle r.value.title}}

      <div>
        <ArtDetails @art={{r.value}}/>
      </div>
    {{/if}}
  {{/let}}
</template>);
