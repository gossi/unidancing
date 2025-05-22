import { hash } from '@ember/helper';

import {
  formatIndicator,
  formatNumber,
  formatSeconds
} from '@unidancing/app/domain/supporting/utils';

import { Card } from '@hokulea/ember';

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
      <details>
        <summary>
          Effektiv genutzte Zeit
          <span>{{formatSeconds data.duration}}</span>
        </summary>

        <table>
          {{#each data.groups as |group|}}
            <tr>
              <td>{{group.content}}</td>
              <td data-attractivity={{group.attractivity}} class="digits">{{formatNumber
                  group.value
                  (hash signDisplay="exceptZero")
                }}</td>
            </tr>
          {{/each}}
        </table>
      </details>

      <details>
        <summary>
          Effektivitäts Index
          <span>{{formatIndicator data.ratio}}</span>
        </summary>

        {{formatNumber data.ratio (hash style="percent")}}
        der Kürzeit wurde genutzt.
        <meter value={{data.ratio}} max="2" />
        {{! optimum="0.90000001" high="0.9" low="0.7" }}
      </details>
    </Card>
  {{/let}}
</template>;

export { TimeTrackingEffectivityIndicator };
