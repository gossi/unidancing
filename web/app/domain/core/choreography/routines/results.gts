import Component from '@glimmer/component';
import { concat } from '@ember/helper';

import { formatNumber, t } from 'ember-intl';

import { Button } from '@hokulea/ember';

import { CardSection, Features } from '../../../supporting/ui';
import { CriterionInterval, Score } from './-components';
import { toIntlNameKey } from './-utils';
import { getCriterionKey, loadSystem, scoreCategory } from './actions';
import styles from './routines.css';
import { IUF_PERFORMANCE_2019 } from './systems/iuf-performance-2019';

import type {
  JudgingSystem,
  JudgingSystemCategory,
  JudgingSystemCriterion,
  JudgingSystemPart,
  RoutineTest
} from './domain-objects';
import type { TOC } from '@ember/component/template-only';
import type Owner from '@ember/owner';
import type { Link } from 'ember-link';

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

const Artistic: TOC<{
  Args: { system: JudgingSystem };
}> = <template>
  <h2>Artistik</h2>

  {{#each @system.parts as |part|}}
    <Part @system={{@system}} @part={{part}} />
  {{/each}}
</template>;

interface RoutineResultsArgs {
  data?: RoutineTest;
  editLink?: Link;
}

export class RoutineResults extends Component<{
  Args: RoutineResultsArgs;
}> {
  artistic: JudgingSystem;

  constructor(owner: Owner, args: RoutineResultsArgs) {
    super(owner, args);

    this.artistic = loadSystem(IUF_PERFORMANCE_2019, args.data?.artistic);
  }

  <template>
    {{#if @data.artistic}}
      <Artistic @system={{this.artistic}} />
    {{/if}}

    {{#if @editLink}}
      <Button @push={{@editLink}}>Bearbeiten</Button>
    {{/if}}
  </template>
}
