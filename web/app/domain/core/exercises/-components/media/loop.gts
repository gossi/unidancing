import { Loop } from '../../../assistants';
import { data } from '../../../assistants/looper/data';

import type { ExerciseMediaLoop } from '../../domain-objects';
import type { TOC } from '@ember/component/template-only';

function load(id: string) {
  const [trackId, loop] = id.split('.');

  const track = data.find((t) => t.id === trackId);

  return {
    track,
    loop
  };
}

interface LoopSignature {
  Args: {
    media: ExerciseMediaLoop;
  };
}

export const Looper: TOC<LoopSignature> = <template>
  {{#if @media.name}}
    {{#let (load @media.name) as |l|}}
      {{#if l.track}}
        <Loop @track={{l.track}} @loop={{l.loop}} />
      {{/if}}
    {{/let}}
  {{/if}}
</template>;
