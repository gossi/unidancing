import { CardSection } from '../../../../../supporting/ui';
import { Score, ScoreLabel } from '../../artistic/-components.gts';

import type { TOC } from '@ember/component/template-only';

interface CategoryCardSignature {
  Args: {
    name: string;
    score?: number;
  };
  Blocks: {
    default: [];
  };
}

export const CategoryCard: TOC<CategoryCardSignature> = <template>
  <CardSection class="category">
    <:header>
      <hgroup>
        <h4>{{@name}}</h4>
        <p>
          <ScoreLabel>Score:</ScoreLabel>
          <Score @score={{@score}} />
        </p>
      </hgroup>
    </:header>
    <:body>
      {{yield}}
    </:body>
  </CardSection>
  <style scoped>
    .category {
      display: flex;
      flex-direction: column;

      & > * + * {
        margin-block-start: var(--spacing-container0);
      }

      hgroup {
        display: flex;
        flex-direction: column;
        gap: var(--spacing-container-4);
      }

      div {
        gap: var(--spacing-container-4);
      }

      span {
        margin-block-start: var(--spacing-container-4);
      }

      input[type="range"] {
        padding: 0;
      }
    }
  </style>
</template>;
