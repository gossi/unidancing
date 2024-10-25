import Component from '@glimmer/component';

import { findAssistant } from '../assistants';

import type { Assistant } from '../assistants';

export interface AssistantSignature {
  Args: {
    assistant?: Assistant;
  };
}

export class AssistantFactory extends Component<AssistantSignature> {
  // eslint-disable-next-line @typescript-eslint/naming-convention
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
