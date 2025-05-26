import { hash } from '@ember/helper';
import { on } from '@ember/modifier';

import {
  formatIndicator,
  formatNumber,
  formatSeconds
} from '@unidancing/app/domain/supporting/utils';
import { link } from 'ember-link';

import { Card, Icon } from '@hokulea/ember';

import { Explainer, ExplainerTable } from './-explainer';
import { calculateEffectiveness } from './domain';
import styles from './evaluation.css';

import type { TimeAnalysis } from './domain';
import type { TOC } from '@ember/component/template-only';

const EffectivityIndex: TOC<{ Args: { value: number } }> = <template>
  <div class={{styles.effectivityIndex}}>
    <meter value={{@value}} max="2" />
    <span style="--value: 50%">Bonus</span>
  </div>
</template>;

interface TimeTrackingEffectivityIndicatorSignature {
  Args: {
    data: TimeAnalysis;
  };
}

const TimeTrackingEffectivityIndicator: TOC<TimeTrackingEffectivityIndicatorSignature> = <template>
  {{#let (calculateEffectiveness @data) as |data|}}
    <Card class={{styles.indicator}}>
      <h4>
        Effektivität

        {{#let (link "training.diagnostics.time-tracking") as |l|}}
          <a href="{{l.url}}#effectivity" {{on "click" l.open}}><Icon @icon="info" /></a>
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
</template>;

export { TimeTrackingEffectivityIndicator };
