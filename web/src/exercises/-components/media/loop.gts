import { Loop, looperData } from '#assistants';

import type { ExerciseMediaLoop } from '../../domain-objects';
import type { TOC } from '@ember/component/template-only';

function load(id: string) {
  const [trackId, loop] = id.split('.');

  const track = looperData.find((t) => t.id === trackId);

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
