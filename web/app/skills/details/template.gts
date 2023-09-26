import RouteTemplate from 'ember-route-template';
import pageTitle from 'ember-page-title/helpers/page-title';
import { htmlSafe } from '@ember/template';
import type { Skill } from '../../database/skills';

interface Signature {
  Args: {
    model: Skill;
  }
}

export default RouteTemplate<Signature>(<template>
  {{#if @model}}
    {{pageTitle @model.title}}

    <h1>{{@model.title}}</h1>

    {{htmlSafe @model.contents}}
  {{else}}
    <h1>Not Found</h1>

    <p>whoops</p>
  {{/if}}
</template>);
