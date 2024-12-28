import Component from '@glimmer/component';
import { concat } from '@ember/helper';

import { formatNumber, t } from 'ember-intl';

import { CardSection, Features } from '../../../../supporting/ui';
import { CriterionInterval, Score } from './-components';
import { toIntlNameKey } from './-utils';
import { getCriterionKey, scoreCategory } from './actions';
import styles from './artistic.css';

import type {
  JudgingSystem,
  JudgingSystemCategory,
  JudgingSystemCriterion,
  JudgingSystemPart
} from './domain-objects';
import type { TOC } from '@ember/component/template-only';

class Criterion extends Component<{
  Args: {
    criterion: JudgingSystemCriterion;
  };
}> {
  get name() {
    return `artistic-${getCriterionKey(this.args.criterion).replaceAll('.', '-')}`;
  }

  <template>
    {{concat
      (t (toIntlNameKey this.name))
      (if @criterion.value (concat " (" (formatNumber @criterion.value) ")") "")
    }}
    {{#if @criterion.value}}
      <CriterionInterval @criterion={{@criterion}} />
    {{/if}}
  </template>
}

class Category extends Component<{
  Args: {
    system: JudgingSystem;
    category: JudgingSystemCategory;
  };
}> {
  get name() {
    return `artistic-${this.args.category.part.name}-${this.args.category.name}`;
  }

  get score() {
    return scoreCategory(this.args.category);
  }

  <template>
    <CardSection class={{styles.category}}>
      <:header>
        <hgroup>
          <h4>{{t (toIntlNameKey this.name)}}</h4>
          <p>
            <span class={{styles.score}} data-score="label">Score:</span>
            <Score @score={{this.score}} />
          </p>
        </hgroup>
      </:header>
      <:body>
        {{#each @category.criteria as |criterion|}}
          <Criterion @criterion={{criterion}} />
        {{/each}}
      </:body>
    </CardSection>
  </template>
}

const Part: TOC<{
  Args: {
    system: JudgingSystem;
    part: JudgingSystemPart;
  };
}> = <template>
  <Features>
    {{#each @part.categories as |category|}}
      <Category @system={{@system}} @category={{category}} />
    {{/each}}
  </Features>
</template>;

export const ArtisticResults: TOC<{
  Args: { system: JudgingSystem };
}> = <template>
  <h2>Artistik</h2>

  {{#each @system.parts as |part|}}
    <Part @system={{@system}} @part={{part}} />
  {{/each}}
</template>;
