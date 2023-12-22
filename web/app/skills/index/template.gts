import RouteTemplate from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import { load } from 'ember-async-data';
import { findSkills } from '../resource';
import { LinkTo } from '@ember/routing';

export default RouteTemplate(<template>
  {{pageTitle "Fertigkeiten"}}

  <h1>Fertigkeiten</h1>

  {{#let (load (findSkills)) as |r|}}
    {{#if r.isResolved}}

      <ul>
        {{#each r.value as |skill|}}
          <li>
            <LinkTo @route="skills.details" @model={{skill._sys.filename}}>{{skill.title}}</LinkTo>
          </li>
        {{/each}}
      </ul>
    {{/if}}
  {{/let}}
</template>);
