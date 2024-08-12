import { Tag } from '../../../supporting/ui';
import styles from './styles.css';

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
  <Tag class={{styles.tag}} data-difficulty={{@difficulty}}>{{getLabel @difficulty}}</Tag>
</template>;

export default Difficulty;
