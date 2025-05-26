import { hash } from '@ember/helper';

import {
  formatIndicator,
  formatNumber,
  formatSeconds
} from '@unidancing/app/domain/supporting/utils';

import { Card } from '@hokulea/ember';

import { Explainer, ExplainerTable } from './-explainer';
import { calculateEffectiveness } from './domain';
import styles from './evaluation.css';

import type { TimeAnalysis } from './domain';
import type { TOC } from '@ember/component/template-only';

interface TimeTrackingEffectivityIndicatorSignature {
  Args: {
    data: TimeAnalysis;
  };
}

const TimeTrackingEffectivityIndicator: TOC<TimeTrackingEffectivityIndicatorSignature> = <template>
  {{#let (calculateEffectiveness @data) as |data|}}
    <Card class="{{styles.indicator}} {{styles.effectivity}}">
      <h4>Effektivität</h4>

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
          <meter value={{data.indicator}} max="2" />
          {{! optimum="0.90000001" high="0.9" low="0.7" }}
        </:content>
      </Explainer>

    </Card>
  {{/let}}
</template>;

export { TimeTrackingEffectivityIndicator };
