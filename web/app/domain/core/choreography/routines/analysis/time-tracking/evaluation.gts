import { concat } from '@ember/helper';
import { htmlSafe } from '@ember/template';

import { formatNumber } from '@unidancing/app/domain/supporting/utils';

import { CATEGORY_GROUPS } from './domain';
import styles from './timeline.css';

import type { TimeAnalysis, TimeTrackingGroupsEvaluation } from './domain';
import type { TOC } from '@ember/component/template-only';

interface TimeTrackingSummarySignature {
  Args: {
    data: TimeAnalysis;
  };
}

function formatRatio(value: number) {
  return Math.round(value * 100);
}

function getData(data: TimeAnalysis, group: string) {
  return data.evaluation?.[group as keyof TimeTrackingGroupsEvaluation];
}

const TimeTrackingSummary: TOC<TimeTrackingSummarySignature> = <template>
  <table class={{styles.summary}}>
    <thead>
      <tr>
        <th>Messkriterium</th>
        <th colspan="2">Zeit [s]</th>
        <th>Verhältnis [%]</th>
      </tr>
    </thead>
    <tbody>
      {{#each CATEGORY_GROUPS as |group|}}
        {{#let (getData @data group.id) as |data|}}
          <tr>
            <td>{{group.content}}</td>
            {{#if data}}
              <td data-vis>
                <span
                  style={{htmlSafe (concat "--ratio: " (formatRatio data.ratio) "%;")}}
                  data-bar
                  data-group={{group.id}}
                ></span>
              </td>
              <td class="digits">{{formatNumber data.duration}}</td>
              <td class="digits">{{formatRatio data.ratio}}</td>
            {{else}}
              <td></td>
              <td>-</td>
              <td>-</td>
            {{/if}}
          </tr>
        {{/let}}
      {{/each}}
    </tbody>
  </table>
</template>;

export { TimeTrackingSummary };
