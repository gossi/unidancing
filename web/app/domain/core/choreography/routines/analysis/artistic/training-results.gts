import Component from '@glimmer/component';

import { formatNumber, t } from 'ember-intl';

import { findInterval, loadSystem, loadSystemDescriptor } from '../systems/actions';
import { Score } from './-components';
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

function getCriterion(part: PartResult, category: CategoryResult, criterion: CriterionResult) {
  const cat = part.categories.find((c) => c.name === category.name);

  return cat?.criteria.find((cri) => cri.name === criterion.name) as JudgingSystemCriterion;
}

class Diff extends Component<{ Args: { value: number } }> {
  get sign() {
    return this.args.value > 0 ? '+' : '';
  }

  <template>
    <span class={{styles.diff}} data-sign={{this.sign}}>{{this.sign}}{{formatNumber
        @value
        maximumFractionDigits=2
      }}</span>
  </template>
}

class Criterion extends Component<{
  Args: {
    criterion: CriterionResult;
    category: CategoryResult;
    part: PartResult;
    system: JudgingSystem;
    reference: Results;
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

  get reference() {
    return getCriterion(
      this.args.reference.parts.find(
        (p) => p.name === this.args.part.name
      ) as unknown as PartResult,
      this.args.category,
      this.args.criterion
    );
  }

  get diff() {
    return this.args.criterion.value - this.reference.value;
  }

  get name() {
    return `artistic-${getCriterionKey(this.criterion).replaceAll('.', '-')}`;
  }

  <template>
    <tr>
      <td>{{t (toIntlNameKey this.name)}}</td>
      <td><Score @score={{@criterion.value}} /></td>
      <td><Score @score={{this.reference.value}} /></td>
      <td><Diff @value={{this.diff}} /></td>
    </tr>
  </template>
}

class Category extends Component<{
  Args: {
    category: CategoryResult;
    part: PartResult;
    system: JudgingSystem;
    reference: Results;
  };
}> {
  get name() {
    return `artistic-${this.args.part.name}-${this.args.category.name}`;
  }

  get reference() {
    return (
      this.args.reference.parts.find((p) => p.name === this.args.part.name) as PartResult
    ).categories.find((c) => c.name === this.args.category.name) as CategoryResult;
  }

  get diff() {
    return this.args.category.score - this.reference.score;
  }

  <template>
    <tbody>
      <tr>
        <th>{{t (toIntlNameKey this.name)}}</th>
        <th><Score @score={{@category.score}} /></th>
        <th><Score @score={{this.reference.score}} /></th>
        <th><Diff @value={{this.diff}} /></th>
      </tr>
      {{#each @category.criteria as |criterion|}}
        <Criterion
          @system={{@system}}
          @part={{@part}}
          @category={{@category}}
          @criterion={{criterion}}
          @reference={{@reference}}
        />
      {{/each}}
    </tbody>
  </template>
}

class Part extends Component<{
  Args: {
    part: PartResult;
    system: JudgingSystem;
    reference: Results;
  };
}> {
  get reference() {
    return this.args.reference.parts.find((p) => p.name === this.args.part.name) as PartResult;
  }

  get diff() {
    return this.args.part.score - this.reference.score;
  }

  <template>
    {{! template-lint-disable table-groups  }}
    <table class={{styles.training}}>
      <thead>
        <tr>
          <td></td>
          <td>Deine Wertung</td>
          <td>Reference</td>
          <td>Diff</td>
        </tr>
        <tr>
          <th>Total</th>
          <th><Score @score={{@part.score}} /></th>
          <th><Score @score={{this.reference.score}} /></th>
          <th><Diff @value={{this.diff}} /></th>
        </tr>
      </thead>
      {{#each @part.categories as |category|}}
        <Category
          @system={{@system}}
          @part={{@part}}
          @category={{category}}
          @reference={{@reference}}
        />
      {{/each}}
    </table>
  </template>
}

export class ArtisticTrainingResults extends Component<{
  Args: { data: Results; reference: Results };
}> {
  get system() {
    return loadSystem(loadSystemDescriptor(this.args.data.name));
  }

  <template>
    {{#each @data.parts as |part|}}
      <Part @system={{this.system}} @part={{part}} @reference={{@reference}} />
    {{/each}}
  </template>
}
