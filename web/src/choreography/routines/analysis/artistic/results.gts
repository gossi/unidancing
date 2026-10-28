import Component from '@glimmer/component';
import { concat } from '@ember/helper';

import { CategoryCard } from '@unidancing/app/domain/core/choreography/routines/analysis/artistic/-components.gts';
import { formatNumber, t } from 'ember-intl';

import { Features } from '../../../../../supporting/ui';
import { CriterionInterval, Score } from '../../artistic/-components';
import { getCriterionKey, toIntlNameKey } from '../../artistic/-utils';
import { findInterval, loadSystem, loadSystemDescriptor } from '../../systems/actions';

import type {
  ArtisticResults as Results,
  CategoryResult,
  CriterionResult,
  PartResult
} from '../../artistic/domain-objects';
import type {
  JudgingSystem,
  JudgingSystemCriterion,
  JudgingSystemCriterionInterval
} from '../../systems/domain-objects';
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
    <div class="criterion">
      {{concat
        (t (toIntlNameKey this.name))
        (if @criterion.value (concat " (" (formatNumber @criterion.value) ")") "")
      }}
      {{#if @criterion.value}}
        <CriterionInterval @criterion={{this.criterion}} @interval={{this.interval}} />
      {{/if}}
    </div>
    <style scoped>
      .criterion {
        display: flex;
        flex-direction: column;
      }
    </style>
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
    <CategoryCard @name={{t (toIntlNameKey this.name)}} @score={{@category.score}}>
      {{#each @category.criteria as |criterion|}}
        <Criterion
          @system={{@system}}
          @part={{@part}}
          @category={{@category}}
          @criterion={{criterion}}
        />
      {{/each}}
    </CategoryCard>
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
      <span data-score="label">Score:</span>
      <Score @score={{this.score}} />
    </p>

    {{#each @data.parts as |part|}}
      <Part @system={{this.system}} @part={{part}} />
    {{/each}}
  </template>
}
