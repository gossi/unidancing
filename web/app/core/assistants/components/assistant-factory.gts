import Component from '@glimmer/component';
import { findAssistant } from '../assistants';
import type { Assistant } from '../assistants';

export interface AssistantSignature {
  Args: {
    assistant?: Assistant;
  };
}

export class AssistantFactory extends Component<AssistantSignature> {
  get Assistant() {
    return findAssistant(this.args.assistant);
  }

  <template>
    {{#if this.Assistant}}
      {{!@glint-ignore}}
      <this.Assistant />
    {{/if}}
  </template>
}
