import RouteTemplate from 'ember-route-template';
import pageTitle from 'ember-page-title/helpers/page-title';
import type { Skill } from '../../database/skills';
import { LinkTo } from '@ember/routing';

interface Signature {
  Args: {
    model: Skill[];
  }
}

export default RouteTemplate<Signature>(<template>
  {{pageTitle "Fertigkeiten"}}

  <h1>Fertigkeiten</h1>

  <ul>
    {{#each @model as |entry|}}
      <li><LinkTo @route="skills.details" @model={{entry.id}}>{{entry.title}}</LinkTo></li>
    {{/each}}
  </ul>
</template>);
