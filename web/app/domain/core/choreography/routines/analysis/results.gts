import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';

import { not, or } from 'ember-truth-helpers';

import { Tabs } from '@hokulea/ember';

import { YoutubePlayer } from '../../../../supporting/youtube';
import styles from './analysis.css';
import { ArtisticResults } from './artistic/results';
import { ArtisticSummary } from './artistic/summary';
import { NotTodoListResults } from './not-todo-list/results';
import { TimeTrackingBalanceIndicator } from './time-tracking/balance-indicator';
import { TimeTrackingEffectivityIndicator } from './time-tracking/effectivity-indicator';
import { TimeTrackingSummary } from './time-tracking/evaluation';
import { TimeTrackingResults } from './time-tracking/results';
import { TricksStub } from './tricks/stub';

import type { YoutubePlayerAPI } from '../../../../supporting/youtube';
import type { RoutineResult } from './domain-objects';
import type { Link } from 'ember-link';

function length(arr: unknown[]) {
  return arr.length;
}

interface RoutineResultsArgs {
  data: RoutineResult;
  editLink?: Link;
}

export class RoutineResults extends Component<{
  Args: RoutineResultsArgs;
}> {
  @tracked player?: YoutubePlayerAPI;
  @tracked selection?: string;

  setPlayerApi = (api: YoutubePlayerAPI) => {
    this.player = api;
  };

  selectTab = (tab: string) => {
    this.selection = tab;
  };

  <template>
    <YoutubePlayer @url={{@data.video}} @setApi={{this.setPlayerApi}} />

    <div class={{styles.tabs}}>
      <Tabs as |tabs|>
        <tabs.Tab @label="Zusammenfassung">
          {{#if (not (or @data.timeTracking @data.artistic @data.notTodoList))}}
            Nanu? Diese Kür hat keine Messwerte 🤷
          {{/if}}

          {{#if @data.timeTracking}}
            <h3>Zeitaufteilung</h3>
            <TimeTrackingSummary @data={{@data.timeTracking}} />

            <div class={{styles.indicators}}>
              <TimeTrackingEffectivityIndicator @data={{@data.timeTracking}} />
              <TimeTrackingBalanceIndicator @data={{@data.timeTracking}} />
            </div>
          {{/if}}

          {{#if @data.artistic}}
            <h3>Artistik</h3>
            {{!-- <Button @importance="plain" @push={{fn this.selectTab "artistry"}}>
              Details
              <Icon @icon="caret-double-right" />
            </Button> --}}

            <ArtisticSummary @data={{@data.artistic}} />

          {{/if}}

          {{#if @data.notTodoList}}
            <h3>Not Todo List</h3>

            Die Kür beinhaltet
            {{length @data.notTodoList}}
            Dinge, die besser nicht darin vorkommen.
          {{/if}}
        </tabs.Tab>

        {{#if @data.timeTracking}}
          <tabs.Tab @label="Zeitaufteilung" as |state|>
            <TimeTrackingResults
              @data={{@data.timeTracking}}
              @playerApi={{this.player}}
              @active={{state.active}}
            />

            <div class={{styles.indicators}}>
              <TimeTrackingEffectivityIndicator @data={{@data.timeTracking}} />
              <TimeTrackingBalanceIndicator @data={{@data.timeTracking}} />
            </div>
          </tabs.Tab>
        {{/if}}

        <tabs.Tab @label="Tricks">
          <TricksStub />
        </tabs.Tab>

        {{#if @data.artistic}}
          <tabs.Tab @value="artistry" @label="Artistik">
            <ArtisticResults @data={{@data.artistic}} />
          </tabs.Tab>
        {{/if}}

        {{#if @data.notTodoList}}
          <tabs.Tab @label="Not Todo List">
            <NotTodoListResults @data={{@data.notTodoList}} />
          </tabs.Tab>
        {{/if}}
      </Tabs>
    </div>
  </template>
}
