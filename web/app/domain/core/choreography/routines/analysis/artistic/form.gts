import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { concat } from '@ember/helper';
import { on } from '@ember/modifier';

import { formatNumber, t } from 'ember-intl';

import { CardSection, Features } from '../../../../../supporting/ui';
import { findInterval, loadSystem, loadSystemDescriptor } from '../systems/actions';
import { CriterionInterval, Score } from './-components';
import { getCriterionKey, toIntlNameKey } from './-utils';
import { scoreArtistic } from './actions';
import styles from './artistic.css';

import type {
  JudgingSystem,
  JudgingSystemCategory,
  JudgingSystemCriterion,
  JudgingSystemID,
  JudgingSystemPart
} from '../systems/domain-objects';
import type {
  ArtisticResults,
  CategoryResult,
  CriterionResult,
  PartResult,
  WireArtisticResults
} from './domain-objects';
import type { TOC } from '@ember/component/template-only';
import type Owner from '@ember/owner';
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

export function loadArtisticData(data: WireArtisticResults): ArtisticFormData {
  const results: ArtisticFormData = {
    ...ARTISTIC_FORM_DATA
  };

  for (const p of data.parts) {
    for (const c of p.categories) {
      for (const cr of c.criteria) {
        const key = toDataKey(`${p.name}.${c.name}.${cr.name}`) as keyof ArtisticFormData;

        results[key] = cr.value;
      }
    }
  }

  return results;
}

export function parseArtisticFormData(
  data: Partial<ArtisticFormData>,
  name: JudgingSystemID
): WireArtisticResults {
  const results: Partial<WireArtisticResults> = {
    name
  };

  const filteredData = Object.fromEntries(
    Object.entries(data).filter(([k]) => k.startsWith('artistic-'))
  );

  for (const [path, v] of Object.entries(filteredData)) {
    const [, partName, categoryName, criterionName] = path.split('-');

    if (!results.parts) {
      results.parts = [];
    }

    let part = results.parts.find((p) => p.name === partName);

    if (!part) {
      part = { name: partName, categories: [] };
      results.parts.push(part);
    }

    let category = part.categories.find((c) => c.name === categoryName);

    if (!category) {
      category = { name: categoryName, criteria: [] };
      part.categories.push(category);
    }

    category.criteria.push({ name: criterionName, value: v });
  }

  return results as WireArtisticResults;
}

interface CriterionSignature {
  Args: {
    form: FormBuilder<ArtisticFormData, void>;
    criterion: JudgingSystemCriterion;
    updateScore: (name: keyof ArtisticFormData, value: number) => void;
    results?: ArtisticResults;
  };
}

class Criterion extends Component<CriterionSignature> {
  constructor(owner: Owner, args: CriterionSignature['Args']) {
    super(owner, args);

    if (args.results) {
      try {
        const value = (
          (
            (
              this.args.results?.parts.find((p) => p.name === 'performance') as PartResult
            ).categories.find((c) => c.name === this.args.criterion.category.name) as CategoryResult
          ).criteria.find((c) => c.name === this.args.criterion.name) as CriterionResult
        ).value;

        if (value) {
          this.value = value;
        }
      } catch {
        /**/
      }
    }
  }

  @tracked value?: number;

  get name() {
    return `artistic-${getCriterionKey(this.args.criterion).replaceAll(
      '.',
      '-'
    )}` as keyof ArtisticFormData;
  }

  updateScore = (e: InputEvent) => {
    const target = e.target as HTMLInputElement;

    this.value = target.valueAsNumber;
    this.args.updateScore(target.name as keyof ArtisticFormData, target.valueAsNumber);
  };

  <template>
    {{#let @form as |f|}}
      <f.Range
        @name={{this.name}}
        @label={{concat
          (t (toIntlNameKey this.name))
          (if this.value (concat " (" (formatNumber this.value) ")") "")
        }}
        {{on "input" this.updateScore}}
        min="0"
        max="10"
        step="0.1"
      />

      {{#if this.value}}
        {{#let (findInterval @criterion.intervals this.value) as |interval|}}
          {{#if interval}}
            <CriterionInterval @criterion={{@criterion}} @interval={{interval}} />
          {{/if}}
        {{/let}}
      {{/if}}
    {{/let}}
  </template>
}

class Category extends Component<{
  Args: {
    form: FormBuilder<ArtisticFormData, void>;
    results?: ArtisticResults;
    updateScore: (name: keyof ArtisticFormData, value: number) => void;
    category: JudgingSystemCategory;
  };
}> {
  get name() {
    return `artistic-${this.args.category.part.name}-${this.args.category.name}`;
  }

  get score() {
    let score = undefined;

    try {
      score = (
        (
          this.args.results?.parts.find((p) => p.name === 'performance') as PartResult
        ).categories.find((c) => c.name === this.args.category.name) as CategoryResult
      ).score;
    } catch {
      /**/
    }

    return score;
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
          <Criterion
            @form={{@form}}
            @criterion={{criterion}}
            @results={{@results}}
            @updateScore={{@updateScore}}
          />
        {{/each}}
      </:body>
    </CardSection>
  </template>
}

const Part: TOC<{
  Args: {
    form: FormBuilder<ArtisticFormData, void>;
    results?: ArtisticResults;
    updateScore: (name: keyof ArtisticFormData, value: number) => void;
    part: JudgingSystemPart;
  };
}> = <template>
  <Features>
    {{#each @part.categories as |category|}}
      <Category
        @form={{@form}}
        @results={{@results}}
        @updateScore={{@updateScore}}
        @category={{category}}
      />
    {{/each}}
  </Features>
</template>;

interface ArtisticFormSignature {
  Args: {
    form: FormBuilder<ArtisticFormData, void>;
    systemID: JudgingSystemID;
    results?: WireArtisticResults;
  };
}

export class ArtisticForm extends Component<ArtisticFormSignature> {
  data: Partial<ArtisticFormData> = {};
  @tracked results?: ArtisticResults;

  system: JudgingSystem;

  constructor(owner: Owner, args: ArtisticFormSignature['Args']) {
    super(owner, args);

    this.system = loadSystem(loadSystemDescriptor(this.args.systemID));

    if (args.results) {
      this.results = scoreArtistic(this.system, args.results);
    }
  }

  get score() {
    let score = undefined;

    try {
      score = (this.results?.parts.find((p) => p.name === 'performance') as PartResult).score;
    } catch {
      /**/
    }

    return score;
  }

  updateScore = (name: keyof ArtisticFormData, value: number) => {
    this.data[name] = value;
    this.results = scoreArtistic(this.system, parseArtisticFormData(this.data, this.args.systemID));
  };

  <template>
    <p>
      <span class={{styles.score}} data-score="label">Score:</span>
      <Score @score={{this.score}} />
    </p>

    {{#each this.system.parts as |part|}}
      <Part
        @form={{@form}}
        @results={{this.results}}
        @updateScore={{this.updateScore}}
        @part={{part}}
      />
    {{/each}}
  </template>
}
