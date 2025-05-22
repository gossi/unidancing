import { concat } from '@ember/helper';
import { htmlSafe } from '@ember/template';

import { formatPercent, formatSeconds } from '@unidancing/app/domain/supporting/utils';

import { Card } from '@hokulea/ember';

import { calculateBalance } from './domain';
import styles from './evaluation.css';

import type { Balance, TimeAnalysis } from './domain';
import type { TOC } from '@ember/component/template-only';

interface TimeTrackingBalanceIndicatorSignature {
  Args: {
    data: TimeAnalysis;
  };
}

function formatRatio(value: number) {
  return Math.round(value * 100);
}

type BalanceUI = {
  artistry: Balance['artistry'] & {
    ui: {
      barWidth: number;
    };
  };
  technical: Balance['technical'] & {
    ui: {
      barWidth: number;
    };
  };
};

function withBarWidth(data: Balance) {
  const d: BalanceUI = {
    artistry: {
      ...data.artistry,
      ui: {
        barWidth: data.artistry.ratio
      }
    },
    technical: {
      ...data.technical,
      ui: {
        barWidth: data.technical.ratio
      }
    }
  };

  if (data.artistry.ratio + data.technical.ratio > 1) {
    d.artistry.ui.barWidth = data.artistry.relative;
    d.technical.ui.barWidth = data.technical.relative;
  }

  return d;
}

const TimeTrackingBalanceIndicator: TOC<TimeTrackingBalanceIndicatorSignature> = <template>
  {{#let (withBarWidth (calculateBalance @data)) as |data|}}
    <Card class={{styles.indicator}}>
      <h4>Balance</h4>
      <div class={{styles.balance}}>
        <div>
          <span data-ratio>{{formatPercent data.artistry.relative}}</span>
          <span data-duration>{{formatSeconds data.artistry.duration}}
            ({{formatPercent data.artistry.ratio}})</span>
          <span
            style={{htmlSafe
              (concat "--ratio: calc(" (formatRatio data.artistry.relative) "% * 2);")
            }}
            data-bar
            data-group="artistry"
          ></span>
          <small>Artistik</small>
        </div>

        <div>
          <span data-ratio>{{formatPercent data.technical.relative}}</span>
          <span data-duration>{{formatSeconds data.technical.duration}}
            ({{formatPercent data.technical.ratio}})</span>
          <span
            style={{htmlSafe
              (concat "--ratio: calc(" (formatRatio data.technical.relative) "% * 2);")
            }}
            data-bar
            data-group="tricks"
          ></span>
          <small>Tricks</small>
        </div>
      </div>
    </Card>
  {{/let}}
</template>;

export { TimeTrackingBalanceIndicator };
