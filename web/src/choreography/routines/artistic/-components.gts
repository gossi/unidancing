import Component from '@glimmer/component';

import { formatNumber, t } from 'ember-intl';

import { getCriterionKey, toIntlIntervalKey } from './-utils';

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
    <span data-marker={{@interval.marker}} class="interval">
      {{t (toIntlIntervalKey this.name @interval.marker)}}
    </span>
    <style scoped>
      .interval {
        font-size: var(--s-1);

        &[data-marker="0"],
        &[data-marker="1"],
        &[data-marker="2"],
        &[data-marker="3"],
        &[data-marker="4"] {
          color: var(--indicator-error-plain-text);
        }

        &[data-marker="5"],
        &[data-marker="6"],
        &[data-marker="7"] {
          color: var(--indicator-warning-plain-text);
        }

        &[data-marker="8"],
        &[data-marker="9"] {
          color: var(--indicator-success-plain-text);
        }
      }
    </style>
  </template>
}

export const ScoreLabel: TOC<{ Blocks: { default: [] } }> = <template>
  <span class="score" data-score="label">{{yield}}</span>
  <style scoped>
    .score {
      &[data-score="label"] {
        color: var(--typography-subtle);
      }
    }
  </style>
</template>;

export const Score: TOC<{ Args: { score?: number } }> = <template>
  {{#if @score}}
    <span class="score" data-score="value">{{formatNumber @score maximumFractionDigits=2}}</span>
  {{else}}
    -
  {{/if}}
  <style scoped>
    .score {
      &[data-score="value"] {
        font-size: 110%;
      }
    }
  </style>
</template>;
