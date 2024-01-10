import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';
import { findAssistant } from '../assistants';
import type { Assistant} from '../assistants';

export class AssistantsRoute extends Route<{ assistant: string }> {
  get Assistant() {
    return findAssistant(this.params.assistant as Assistant);
  }

  <template>
    {{#if this.Assistant}}
      {{!@glint-ignore}}
      <this.Assistant />
    {{/if}}
  </template>
}

export default CompatRoute(AssistantsRoute);
