import { concat } from '@ember/helper';
import { htmlSafe } from '@ember/template';

import { formatPercent, formatSeconds } from '@unidancing/app/domain/supporting/utils';
import { link } from 'ember-link';

import IconInfo from '~icons/ph/info';

import { Card, Icon, Tabs } from '@hokulea/ember';

import { Explainer, ExplainerTable } from './-explainer';
import { calculateBalance } from './domain';

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
    <Card class="indicator">
      <h4>
        Balance
        {{#let (link "training.diagnostics.time-tracking") as |l|}}
          <a href="{{l.url}}#effectivity" {{on "click" l.open}}><Icon @icon={{IconInfo}} /></a>
        {{/let}}
      </h4>

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
        <t.Tab @label="Gewichtet">
          <div class="balance">
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

        <t.Tab @label="Absolut">
          <div class="balance">
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
          <div class="balance">
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
      </Tabs>
    </Card>
  {{/let}}

  <style scoped>
    .indicator {
      :global([part="body"]) {
        display: flex;
        flex-direction: column;
        gap: var(--spacing-container-3);
      }
    }

    .balance {
      display: flex;
      justify-content: space-between;

      div {
        display: flex;
        flex-direction: column;
        flex-grow: 1;
        gap: var(--spacing-primitive-4);
        align-items: flex-start;

        &:last-child {
          align-items: flex-end;
        }
      }

      [data-ratio] {
        font-size: var(--s3);
      }

      [data-bar] {
        display: inline-block;
        width: var(--ratio, 0);
        height: 1em;

        &[data-group="artistry"] {
          background-color: var(--artistry);
        }

        &[data-group="tricks"] {
          background-color: var(--tricks);
        }
      }
    }
  </style>
</template>;

export { TimeTrackingBalanceIndicator };
