import RouteTemplate from 'ember-route-template';
import pageTitle from 'ember-page-title/helpers/page-title';
import Details, { MoveDetailsSignature } from '../-components/details';

interface Signature {
  Args: {
    model: MoveDetailsSignature['Args'];
  };
}

export default RouteTemplate<Signature>(<template>
  {{#let @model.move as |move|}}
    {{#if move}}
      {{pageTitle move.title}}

      <Details
        @move={{@model.move}}
        @buildMoveLink={{@model.buildMoveLink}}
        @buildSkillLink={{@model.buildSkillLink}}
        @buildGameLink={{@model.buildGameLink}}
      />
    {{else}}
      <h1>Not Found</h1>

      <p>whoops</p>
    {{/if}}
  {{/let}}
</template>);
