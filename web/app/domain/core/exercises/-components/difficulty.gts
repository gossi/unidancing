import { Tag } from '../../../supporting/ui';

import type { Difficulty as ExerciseDifficulty } from '../domain-objects';
import type { TOC } from '@ember/component/template-only';

const locales: Record<ExerciseDifficulty, string> = {
  beginner: 'Einsteiger',
  intermediate: 'Mittel',
  advanced: 'Fortgeschritten'
};

function getLabel(difficulty: ExerciseDifficulty) {
  return locales[difficulty];
}

interface DifficultySignature {
  Args: {
    difficulty: ExerciseDifficulty;
  };
}

const Difficulty: TOC<DifficultySignature> = <template>
  <Tag class="tag" data-difficulty={{@difficulty}}>{{getLabel @difficulty}}</Tag>
  <style scoped>
    .tag {
      color: var(--typography-main);

      &[data-difficulty="beginner"] {
        --color: #aceca1;

        background-color: var(--color);

        /* color: color-contrast(var(--color) vs var(--typography-main), var(--typography-inverse)); */
      }

      &[data-difficulty="intermediate"] {
        --color: #91b7c7;

        background-color: var(--color);

        /* color: color-contrast(var(--color) vs var(--typography-main), var(--typography-inverse)); */
      }

      &[data-difficulty="advanced"] {
        --color: #d0aae3;

        background-color: var(--color);

        /* color: color-contrast(var(--color) vs var(--typography-main), var(--typography-inverse)); */
      }

      @media (prefers-color-scheme: dark) {
        color: var(--typography-inverse);
      }
    }
  </style>
</template>;

export default Difficulty;
