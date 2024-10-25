import { isDanceMix, isLoop, isMaterial, isSong } from '../domain-objects';
import { DanceMix } from './media/dance-mix';
import { Looper } from './media/loop';
import { Song } from './media/song';

import type { ExerciseMedia } from '../domain-objects';
import type { TOC } from '@ember/component/template-only';

interface MediaSignature {
  Args: {
    media: ExerciseMedia[];
  };
}

export const Media: TOC<MediaSignature> = <template>
  {{#each @media as |m|}}
    {{#if (isDanceMix m)}}
      <DanceMix @media={{m}} />
    {{/if}}

    {{#if (isLoop m)}}
      <Looper @media={{m}} />
    {{/if}}

    {{#if (isSong m)}}
      <Song @media={{m}} />
    {{/if}}

    {{#if (isMaterial m)}}
      <ul>
        {{#each m.material as |item|}}
          <li>{{item}}</li>
        {{/each}}
      </ul>
    {{/if}}
  {{/each}}
</template>;
