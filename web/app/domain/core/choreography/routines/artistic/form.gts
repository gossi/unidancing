import Component from '@glimmer/component';
import { concat } from '@ember/helper';

import { formatNumber, t } from 'ember-intl';

import { CardSection, Features } from '../../../../supporting/ui';
import { CriterionInterval, Score } from './-components';
import { toIntlNameKey } from './-utils';
import { getCriterionKey, scoreCategory, scorePart } from './actions';
import styles from './artistic.css';

import type {
  JudgingSystem,
  JudgingSystemCategory,
  JudgingSystemCriterion,
  JudgingSystemPart
} from './domain-objects';
import type { TOC } from '@ember/component/template-only';
import type { FormBuilder } from '@hokulea/ember';

/* eslint-disable @typescript-eslint/naming-convention */
export interface ArtisticFormData {
  'artistic-performance-execution-presence': number;
  'artistic-performance-execution-carriage': number;
  'artistic-performance-execution-authenticity': number;
  'artistic-performance-execution-clarity': number;
  'artistic-performance-execution-variety': number;
  'artistic-performance-execution-projection': number;
  'artistic-performance-choreography-purpose': number;
  'artistic-performance-choreography-harmony': number;
  'artistic-performance-choreography-utilization': number;
  'artistic-performance-choreography-dynamics': number;
  'artistic-performance-choreography-imaginativeness': number;
  'artistic-performance-music-realization': number;
  'artistic-performance-music-expression': number;
  'artistic-performance-music-finesse': number;
  'artistic-performance-music-timing': number;
}

export const ARTISTIC_FORM_DATA = {
  'artistic-performance-execution-presence': 0,
  'artistic-performance-execution-carriage': 0,
  'artistic-performance-execution-authenticity': 0,
  'artistic-performance-execution-clarity': 0,
  'artistic-performance-execution-variety': 0,
  'artistic-performance-execution-projection': 0,
  'artistic-performance-choreography-purpose': 0,
  'artistic-performance-choreography-harmony': 0,
  'artistic-performance-choreography-utilization': 0,
  'artistic-performance-choreography-dynamics': 0,
  'artistic-performance-choreography-imaginativeness': 0,
  'artistic-performance-music-realization': 0,
  'artistic-performance-music-expression': 0,
  'artistic-performance-music-finesse': 0,
  'artistic-performance-music-timing': 0
};
/* eslint-enable @typescript-eslint/naming-convention */

function toDataKey(name: string) {
  return ('artistic-' + name.replaceAll('.', '-')) as keyof ArtisticFormData;
}

export function loadArtisticData(data: ArtisticFormData, system: JudgingSystem) {
  for (const p of system.parts) {
    for (const c of p.categories) {
      for (const cr of c.criteria) {
        const key = toDataKey(getCriterionKey(cr)) as keyof ArtisticFormData;

        data[key] = cr.value;
      }
    }
  }
}

export function updateArtisticData(data: ArtisticFormData, system: JudgingSystem) {
  for (const p of system.parts) {
    for (const c of p.categories) {
      for (const cr of c.criteria) {
        cr.value = data[toDataKey(getCriterionKey(cr))] as number;
      }
    }
  }
}

export function parseArtisticFormData(
  system: JudgingSystem,
  data: ArtisticFormData
): JudgingSystem {
  const results = {
    ...system,
    parts: system.parts.map((part) => ({
      ...part,
      categories: part.categories.map((category) => ({
        ...category,
        criteria: category.criteria.map((criterion) => ({
          ...criterion,
          value: data[toDataKey(getCriterionKey(criterion))] as number
        }))
      }))
    }))
  };

  return results;
}

class Criterion extends Component<{
  Args: {
    form: FormBuilder<ArtisticFormData, void>;
    criterion: JudgingSystemCriterion;
  };
}> {
  get name() {
    return `artistic-${getCriterionKey(this.args.criterion).replaceAll(
      '.',
      '-'
    )}` as keyof ArtisticFormData;
  }

  <template>
    {{#let @form as |f|}}
      <f.Range
        @name={{this.name}}
        @label={{concat
          (t (toIntlNameKey this.name))
          (if @criterion.value (concat " (" (formatNumber @criterion.value) ")") "")
        }}
        min="0"
        max="10"
        step="0.1"
      />

      {{#if @criterion.value}}
        <CriterionInterval @criterion={{@criterion}} />
      {{/if}}
    {{/let}}
  </template>
}

class Category extends Component<{
  Args: {
    form: FormBuilder<ArtisticFormData, void>;
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
          <Criterion @form={{@form}} @criterion={{criterion}} />
        {{/each}}
      </:body>
    </CardSection>
  </template>
}

const Part: TOC<{
  Args: {
    form: FormBuilder<ArtisticFormData, void>;
    system: JudgingSystem;
    part: JudgingSystemPart;
  };
}> = <template>
  <Features>
    {{#each @part.categories as |category|}}
      <Category @form={{@form}} @system={{@system}} @category={{category}} />
    {{/each}}
  </Features>
</template>;

export class ArtisticForm extends Component<{
  Args: { form: FormBuilder<ArtisticFormData, void>; system: JudgingSystem; video?: string };
}> {
  get score() {
    const partResults = this.args.system.parts.find(
      (p) => p.name === 'performance'
    ) as JudgingSystemPart;

    return scorePart(partResults);
  }

  <template>
    <p>
      <span class={{styles.score}} data-score="label">Score:</span>
      <Score @score={{this.score}} />
    </p>

    {{#each @system.parts as |part|}}
      <Part @form={{@form}} @system={{@system}} @part={{part}} />
    {{/each}}
  </template>
}
