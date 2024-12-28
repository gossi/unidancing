import Component from '@glimmer/component';

import { formatNumber, t } from 'ember-intl';

import { toIntlIntervalKey } from './-utils';
import { findInterval, getCriterionKey } from './actions';
import styles from './artistic.css';

import type { JudgingSystemCriterion } from './domain-objects';
import type { TOC } from '@ember/component/template-only';

export class CriterionInterval extends Component<{
  Args: {
    criterion: JudgingSystemCriterion;
  };
}> {
  get name() {
    return `artistic-${getCriterionKey(this.args.criterion).replaceAll('.', '-')}`;
  }

  <template>
    {{#let (findInterval @criterion) as |interval|}}
      {{#if interval}}
        <span data-marker={{interval.marker}} class={{styles.interval}}>
          {{t (toIntlIntervalKey this.name interval.marker)}}
        </span>
      {{/if}}
    {{/let}}
  </template>
}

export const Score: TOC<{ Args: { score?: number } }> = <template>
  {{#if @score}}
    <span class={{styles.score}} data-score="value">{{formatNumber
        @score
        maximumFractionDigits=2
      }}</span>
  {{else}}
    -
  {{/if}}
</template>;
