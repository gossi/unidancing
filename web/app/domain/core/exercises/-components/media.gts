import { DanceMix } from './media/dance-mix';
import { Looper } from './media/loop';
import { Song } from './media/song';

import type {
  ExerciseInstructionMedia,
  ExerciseMedia,
  ExerciseMediaDancemix,
  ExerciseMediaLoop,
  ExerciseMediaSong
} from '../domain-objects';
import type { TOC } from '@ember/component/template-only';

interface MediaSignature {
  Args: {
    media: ExerciseMedia[];
  };
}

function isDanceMix(
  media: ExerciseMedia | ExerciseInstructionMedia
): media is ExerciseMediaDancemix {
  return (
    media.__typename === 'ExerciseMediaDancemix' ||
    media.__typename === 'ExerciseInstructionMediaDancemix'
  );
}

function isLoop(media: ExerciseMedia | ExerciseInstructionMedia): media is ExerciseMediaLoop {
  return (
    media.__typename === 'ExerciseMediaLoop' || media.__typename === 'ExerciseInstructionMediaLoop'
  );
}

function isSong(media: ExerciseMedia | ExerciseInstructionMedia): media is ExerciseMediaSong {
  return (
    media.__typename === 'ExerciseMediaSong' || media.__typename === 'ExerciseInstructionMediaSong'
  );
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
  {{/each}}
</template>;
