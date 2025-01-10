import Component from '@glimmer/component';
import { concat } from '@ember/helper';
import { htmlSafe } from '@ember/template';

import { groups } from './domain';
import styles from './timeline.css';

import type { TimeAnalysis, TimeTrackingGroupsEvaluation } from './domain';

interface TimeTrackingEvaluationSignature {
  Args: {
    data: TimeAnalysis;
  };
}

export class TimeTrackingEvaluation extends Component<TimeTrackingEvaluationSignature> {
  getData = (group: string) => {
    return this.args.data.evaluation?.[group as keyof TimeTrackingGroupsEvaluation];
  };

  formatDuration = (duration: number) => {
    return Math.round(duration);
  };

  formatRatio = (ratio: number) => {
    return Math.round(ratio * 100);
  };

  get filteredGroups() {
    return groups.filter((g) => g.id !== 'marker');
  }

  <template>
    <table class={{styles.summary}}>
      <thead>
        <tr>
          <th>Messkriterium</th>
          <th colspan="2">Zeit [s]</th>
          <th>Verhältnis [%]</th>
        </tr>
      </thead>
      <tbody>
        {{#each this.filteredGroups as |group|}}
          {{#let (this.getData group.id) as |data|}}
            <tr>
              <td>{{group.content}}</td>
              {{#if data}}
                <td data-vis>
                  <span
                    style={{htmlSafe (concat "--ratio: " (this.formatRatio data.ratio) "%;")}}
                    data-group={{group.id}}
                  ></span>
                </td>
                <td>{{this.formatDuration data.duration}}</td>
                <td>{{this.formatRatio data.ratio}}</td>
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
  </template>
}
