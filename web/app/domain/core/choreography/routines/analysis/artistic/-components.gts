import Component from '@glimmer/component';

import { formatNumber, t } from 'ember-intl';

import { getCriterionKey, toIntlIntervalKey } from './-utils';
import styles from './artistic.css';

import type {
  JudgingSystemCriterion,
  JudgingSystemCriterionInterval
} from '../systems/domain-objects';
import type { TOC } from '@ember/component/template-only';

export class CriterionInterval extends Component<{
  Args: {
    criterion: JudgingSystemCriterion;
    interval: JudgingSystemCriterionInterval;
  };
}> {
  get name() {
    return `artistic-${getCriterionKey(this.args.criterion).replaceAll('.', '-')}`;
  }

  <template>
    <span data-marker={{@interval.marker}} class={{styles.interval}}>
      {{t (toIntlIntervalKey this.name @interval.marker)}}
    </span>
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
