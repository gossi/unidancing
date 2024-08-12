import { Button } from '@hokulea/ember';

import { buildAssistantLink } from '../../../assistants';

import type { ExerciseMediaDancemix } from '../../domain-objects';
import type { TOC } from '@ember/component/template-only';

const nonAssistantParamKeys = ['__typename', 'name', 'label'];
const filterParams = (assistant: ExerciseMediaDancemix) => {
  if (!assistant) return {};

  const params: Record<string, unknown> = {};

  for (const [k, v] of Object.entries(assistant)) {
    if (!nonAssistantParamKeys.includes(k)) {
      params[k] = v;
    }
  }

  return params;
};

interface DanceMixSignature {
  Args: {
    media: ExerciseMediaDancemix;
  };
}

export const DanceMix: TOC<DanceMixSignature> = <template>
  {{#let (buildAssistantLink "dance-mix" (filterParams @media)) as |link|}}
    <Button @push={{link}}>
      {{#if @media.label}}{{@media.label}}{{else}}Dance Mix{{/if}}
    </Button>
  {{/let}}
</template>;
