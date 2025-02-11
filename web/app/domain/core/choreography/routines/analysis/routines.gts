import { concat } from '@ember/helper';
import { LinkTo } from '@ember/routing';

import { formatDate, t } from 'ember-intl';

import { Score } from '../artistic/-components';
import styles from './routines.css';

import type { RoutineResult } from './domain-objects';
import type { Document } from '@/tina/types';
import type { TOC } from '@ember/component/template-only';

function pathSegment(data: RoutineResult) {
  return (data as unknown as Document)._sys?.relativePath.replace('.json', '');
}

interface RoutinesSignature {
  Args: {
    routines: RoutineResult[];
  };
}

export const Routines: TOC<RoutinesSignature> = <template>
  <table class={{styles.routines}}>
    <thead>
      <tr>
        <th>Fahrer</th>
        <th>Event</th>
        <th>Kür</th>
        <th>Datum</th>
        <th>Artistik</th>
      </tr>
    </thead>
    <tbody>
      {{#each @routines as |routine|}}
        <tr>
          <td><LinkTo
              @route="choreography.routines.details"
              @model={{pathSegment routine}}
            >{{routine.rider}}</LinkTo></td>
          <td>{{routine.event}}</td>
          <td>{{#if routine.type}}
              {{t (concat "choreography.routines.type." routine.type)}}
            {{/if}}
          </td>
          <td>
            {{#if routine.date}}
              <time datetime={{routine.date}}>{{formatDate routine.date}}</time>
            {{/if}}
          </td>
          <td>
            {{#if routine.artistic}}
              <Score @score={{routine.artistic.score}} />
            {{/if}}
          </td>
        </tr>
      {{/each}}

    </tbody>
  </table>
</template>;
