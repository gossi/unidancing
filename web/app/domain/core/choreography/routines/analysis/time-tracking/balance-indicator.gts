import { concat } from '@ember/helper';
import { htmlSafe } from '@ember/template';

import { formatPercent, formatSeconds } from '@unidancing/app/domain/supporting/utils';

import { Card, Tabs } from '@hokulea/ember';

import { Explainer, ExplainerTable } from './-explainer';
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
        barWidth: data.artistry.indicator
      }
    },
    technical: {
      ...data.technical,
      ui: {
        barWidth: data.technical.indicator
      }
    }
  };

  if (data.artistry.indicator + data.technical.indicator > 1) {
    d.artistry.ui.barWidth = data.artistry.ratio;
    d.technical.ui.barWidth = data.technical.ratio;
  }

  return d;
}

const TimeTrackingBalanceIndicator: TOC<TimeTrackingBalanceIndicatorSignature> = <template>
  {{#let (withBarWidth (calculateBalance @data)) as |data|}}
    <Card class={{styles.indicator}}>
      <h4>Balance</h4>

      <Explainer>
        <:title>
          Artistik
          <span>{{formatSeconds data.artistry.duration}}</span>
        </:title>
        <:content>
          <ExplainerTable @groups={{data.artistry.groups}} />
        </:content>
      </Explainer>

      <Explainer>
        <:title>
          Tricks
          <span>{{formatSeconds data.technical.duration}}</span>
        </:title>
        <:content>
          <ExplainerTable @groups={{data.technical.groups}} />
        </:content>
      </Explainer>

      <Tabs as |t|>
        <t.Tab @label="Absolut">
          <div class={{styles.balance}}>
            <div>
              <span data-ratio>{{formatPercent data.artistry.indicator}}</span>
              <span
                style={{htmlSafe
                  (concat "--ratio: calc(" (formatRatio data.artistry.indicator) "% * 2);")
                }}
                data-bar
                data-group="artistry"
              ></span>
              <small>Artistik</small>
            </div>

            <div>
              <span data-ratio>{{formatPercent data.technical.indicator}}</span>
              <span
                style={{htmlSafe
                  (concat "--ratio: calc(" (formatRatio data.technical.indicator) "% * 2);")
                }}
                data-bar
                data-group="tricks"
              ></span>
              <small>Tricks</small>
            </div>
          </div>
        </t.Tab>

        <t.Tab @label="Verhältnis">
          <div class={{styles.balance}}>
            <div>
              <span data-ratio>{{formatPercent data.artistry.ratio}}</span>
              <span
                style={{htmlSafe
                  (concat "--ratio: calc(" (formatRatio data.artistry.ratio) "% * 2);")
                }}
                data-bar
                data-group="artistry"
              ></span>
              <small>Artistik</small>
            </div>

            <div>
              <span data-ratio>{{formatPercent data.technical.ratio}}</span>
              <span
                style={{htmlSafe
                  (concat "--ratio: calc(" (formatRatio data.technical.ratio) "% * 2);")
                }}
                data-bar
                data-group="tricks"
              ></span>
              <small>Tricks</small>
            </div>
          </div>
        </t.Tab>

        <t.Tab @label="Gewichtet">
          <div class={{styles.balance}}>
            <div>
              <span data-ratio>{{formatPercent data.artistry.weighted}}</span>
              <span
                style={{htmlSafe
                  (concat "--ratio: calc(" (formatRatio data.artistry.weighted) "% * 2);")
                }}
                data-bar
                data-group="artistry"
              ></span>
              <small>Artistik</small>
            </div>

            <div>
              <span data-ratio>{{formatPercent data.technical.weighted}}</span>
              <span
                style={{htmlSafe
                  (concat "--ratio: calc(" (formatRatio data.technical.weighted) "% * 2);")
                }}
                data-bar
                data-group="tricks"
              ></span>
              <small>Tricks</small>
            </div>
          </div>
        </t.Tab>
      </Tabs>
      {{!-- <div class={{styles.balance}}>
        <div>
          <span data-ratio>{{formatPercent data.artistry.ratio}}</span>
          <span data-duration>{{formatSeconds data.artistry.duration}}
            ({{formatPercent data.artistry.indicator}})</span>
          <span
            style={{htmlSafe (concat "--ratio: calc(" (formatRatio data.artistry.ratio) "% * 2);")}}
            data-bar
            data-group="artistry"
          ></span>
          <small>Artistik</small>
        </div>

        <div>
          <span data-ratio>{{formatPercent data.technical.ratio}}</span>
          <span data-duration>{{formatSeconds data.technical.duration}}
            ({{formatPercent data.technical.indicator}})</span>
          <span
            style={{htmlSafe
              (concat "--ratio: calc(" (formatRatio data.technical.ratio) "% * 2);")
            }}
            data-bar
            data-group="tricks"
          ></span>
          <small>Tricks</small>
        </div>
      </div> --}}
    </Card>
  {{/let}}
</template>;

export { TimeTrackingBalanceIndicator };
