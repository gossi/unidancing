import Component from '@glimmer/component';
import { concat } from '@ember/helper';

import { formatNumber, t } from 'ember-intl';

import { CardSection, Features } from '../../../../supporting/ui';
import { findInterval, loadSystem, loadSystemDescriptor } from '../systems/actions';
import { CriterionInterval, Score } from './-components';
import { getCriterionKey, toIntlNameKey } from './-utils';
import styles from './artistic.css';

import type {
  JudgingSystem,
  JudgingSystemCriterion,
  JudgingSystemCriterionInterval
} from '../systems/domain-objects';
import type {
  ArtisticResults as Results,
  CategoryResult,
  CriterionResult,
  PartResult
} from './domain-objects';
import type { TOC } from '@ember/component/template-only';

class Criterion extends Component<{
  Args: {
    criterion: CriterionResult;
    category: CategoryResult;
    part: PartResult;
    system: JudgingSystem;
  };
}> {
  get criterion() {
    const part = this.args.system.parts.find((p) => p.name === this.args.part.name);
    const cat = part?.categories.find((c) => c.name === this.args.category.name);

    return cat?.criteria.find(
      (cri) => cri.name === this.args.criterion.name
    ) as JudgingSystemCriterion;
  }

  get interval() {
    return findInterval(
      this.criterion.intervals,
      this.args.criterion.value
    ) as JudgingSystemCriterionInterval;
  }

  get name() {
    return `artistic-${getCriterionKey(this.criterion).replaceAll('.', '-')}`;
  }

  <template>
    <div class={{styles.criterion}}>
      {{concat
        (t (toIntlNameKey this.name))
        (if @criterion.value (concat " (" (formatNumber @criterion.value) ")") "")
      }}
      {{#if @criterion.value}}
        <CriterionInterval @criterion={{this.criterion}} @interval={{this.interval}} />
      {{/if}}
    </div>
  </template>
}

class Category extends Component<{
  Args: {
    category: CategoryResult;
    part: PartResult;
    system: JudgingSystem;
  };
}> {
  get name() {
    return `artistic-${this.args.part.name}-${this.args.category.name}`;
  }

  <template>
    <CardSection class={{styles.category}}>
      <:header>
        <hgroup>
          <h4>{{t (toIntlNameKey this.name)}}</h4>
          <p>
            <span class={{styles.score}} data-score="label">Score:</span>
            <Score @score={{@category.score}} />
          </p>
        </hgroup>
      </:header>
      <:body>
        {{#each @category.criteria as |criterion|}}
          <Criterion
            @system={{@system}}
            @part={{@part}}
            @category={{@category}}
            @criterion={{criterion}}
          />
        {{/each}}
      </:body>
    </CardSection>
  </template>
}

const Part: TOC<{
  Args: {
    part: PartResult;
    system: JudgingSystem;
  };
}> = <template>
  <Features>
    {{#each @part.categories as |category|}}
      <Category @system={{@system}} @part={{@part}} @category={{category}} />
    {{/each}}
  </Features>
</template>;

export class ArtisticResults extends Component<{
  Args: { data: Results };
}> {
  get system() {
    return loadSystem(loadSystemDescriptor(this.args.data.name));
  }

  get score() {
    return (this.args.data.parts.find((p) => p.name === 'performance') as PartResult).score;
  }

  <template>
    <p>
      <span class={{styles.score}} data-score="label">Score:</span>
      <Score @score={{this.score}} />
    </p>

    {{#each @data.parts as |part|}}
      <Part @system={{this.system}} @part={{part}} />
    {{/each}}
  </template>
}
