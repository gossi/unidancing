import { concat } from '@ember/helper';
import { htmlSafe } from '@ember/template';

import { formatNumber } from '@unidancing/app/domain/supporting/utils';

import { CATEGORY_GROUPS } from './domain';

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
  return data.evaluation[group as keyof TimeTrackingGroupsEvaluation];
}

const TimeTrackingSummary: TOC<TimeTrackingSummarySignature> = <template>
  <table class="summary">
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
  <style scoped>
    .summary {
      border-collapse: collapse;

      thead {
        background: var(--surface-container);
      }

      tfoot {
        background: var(--surface-container1);
      }

      thead,
      tbody,
      tfoot {
        border: 1px solid var(--shape-stroke-color);
      }

      th {
        text-align: left;
      }

      th,
      td {
        padding: 0.5rem 0.75rem;

        &:first-child {
          border-inline-end: 1px solid var(--shape-stroke-color);
        }

        &:last-child {
          border-inline-start: 1px solid var(--shape-stroke-color);
        }
      }

      td:last-child,
      td:nth-child(3) {
        text-align: right;
      }

      [data-vis] {
        width: 40%;
      }

      [data-bar] {
        display: inline-block;
        width: var(--ratio, 0);
        height: 1em;

        &[data-group="artistry"] {
          background-color: var(--artistry);
        }

        &[data-group="communication"] {
          background-color: var(--comm);
        }

        &[data-group="tricks"] {
          background-color: var(--tricks);
        }

        &[data-group="filler"] {
          background-color: var(--filler);
        }

        &[data-group="dismounts"] {
          background-color: var(--dismounts);
        }

        &[data-group="void"] {
          background-color: var(--void);
        }
      }
    }
  </style>
</template>;

export { TimeTrackingSummary };
