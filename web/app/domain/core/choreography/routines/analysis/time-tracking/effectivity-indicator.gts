import {
  formatIndicator,
  formatNumber,
  formatSeconds
} from '@unidancing/app/domain/supporting/utils';
import { link } from 'ember-link';

import IconInfo from '~icons/ph/info';

import { Card, Icon } from '@hokulea/ember';

import { Explainer, ExplainerTable } from './-explainer';
import { calculateEffectiveness } from './domain';

import type { TimeAnalysis } from './domain';
import type { TOC } from '@ember/component/template-only';

const EffectivityIndex: TOC<{ Args: { value: number } }> = <template>
  <div class="effectivityIndex">
    <meter value={{@value}} max="2" />
    {{! template-lint-disable  no-inline-styles }}
    <span style="--value: 50%">Bonus</span>
  </div>
  <style scoped>
    .effectivityIndex {
      position: relative;
      min-height: 3em;

      meter {
        width: 100%;
        background: var(--control-background);

        &::-webkit-meter-inner-element {
          grid-template-rows: 1fr;
        }

        &::-webkit-meter-bar {
          border: 0;
          background: var(--control-background);
        }

        &::-moz-meter-bar {
          background: var(--indicator-success-supreme-background);
        }

        &::-webkit-meter-optimum-value {
          background: var(--indicator-success-supreme-background);
        }

        &:-webkit-meter-optimum-value {
          background: var(--indicator-success-supreme-background);
        }
      }

      span {
        position: absolute;
        inset-block-start: 0;
        inset-inline-start: var(--value);

        padding: var(--spacing-primitive-2);
        padding-block-start: calc(var(--spacing-primitive-2) + 1em);
        border-inline-start: 1px solid var(--shape-stroke-color);
      }
    }
  </style>
</template>;

interface TimeTrackingEffectivityIndicatorSignature {
  Args: {
    data: TimeAnalysis;
  };
}

const TimeTrackingEffectivityIndicator: TOC<TimeTrackingEffectivityIndicatorSignature> = <template>
  {{#let (calculateEffectiveness @data) as |data|}}
    <Card class="indicator">
      <h4>
        Effektivität

        {{#let (link "training.diagnostics.time-tracking") as |l|}}
          <a href="{{l.url}}#effectivity" {{on "click" l.open}}><Icon @icon={{IconInfo}} /></a>
        {{/let}}
      </h4>

      <Explainer>
        <:title>
          Effektiv genutzte Zeit
          <span>{{formatSeconds data.duration}}</span>
        </:title>
        <:content>
          <ExplainerTable @groups={{data.groups}} />
        </:content>
      </Explainer>

      <Explainer>
        <:title>
          Effektivitäts Index
          <span>{{formatIndicator data.indicator}}</span>
        </:title>
        <:content>
          {{formatNumber data.indicator (hash style="percent")}}
          der Kürzeit wurde genutzt.
          <EffectivityIndex @value={{data.indicator}} />
        </:content>
      </Explainer>
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
  </style>
</template>;

export { TimeTrackingEffectivityIndicator };
