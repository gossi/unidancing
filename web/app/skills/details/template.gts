import RouteTemplate from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import { TinaMarkdown } from '../../components';
import { load } from 'ember-async-data';
import { findSkill } from '../resource';

interface Signature {
  Args: {
    model: {
      id: string;
    }
  }
}

export default RouteTemplate<Signature>(<template>
  {{#let (load (findSkill @model.id)) as |r|}}
    {{#if r.isResolved}}
      {{pageTitle r.value.title}}

      <section>
        <h1>{{r.value.title}}</h1>

        <TinaMarkdown @content={{r.value.body}} />
      </section>
    {{/if}}
  {{/let}}
</template>);
