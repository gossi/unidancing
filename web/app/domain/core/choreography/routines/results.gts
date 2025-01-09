import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';

import { Button, Tabs } from '@hokulea/ember';

import { YoutubePlayer } from '../../../supporting/youtube';
import { ArtisticResults } from './artistic/results';
import styles from './form.css';
import { NotTodoListResults } from './not-todo-list/results';
import { TimeTrackingResults } from './time-tracking/results';
import { TricksStub } from './tricks/stub';

import type { YoutubePlayerAPI } from '../../../supporting/youtube';
import type { RoutineResult } from './domain-objects';
import type { Link } from 'ember-link';

interface RoutineResultsArgs {
  data: RoutineResult;
  editLink?: Link;
}

export class RoutineResults extends Component<{
  Args: RoutineResultsArgs;
}> {
  @tracked player?: YoutubePlayerAPI;

  setPlayerApi = (api: YoutubePlayerAPI) => {
    this.player = api;
  };

  <template>
    <h2>{{@data.rider}}{{#if @data.event}} @ {{@data.event}}{{/if}}</h2>
    <YoutubePlayer @url={{@data.video}} @setApi={{this.setPlayerApi}} />

    <div class={{styles.tabs}}>
      <Tabs as |tabs|>
        {{! <tabs.Tab @label="Kür">
          <f.Text @name="rider" @label="Fahrer" />
          <f.Select @name="type" @label="Kür" as |s|>
            <s.Option @value="individual">Einzelkür</s.Option>
            <s.Option @value="pair">Paarkür</s.Option>
            <s.Option @value="small-group">Kleingruppe</s.Option>
            <s.Option @value="large-group">Großgruppe</s.Option>
          </f.Select>
          <f.Date @name="date" @label="Datum" />
          <f.Text @name="event" @label="Veranstaltung" />
        </tabs.Tab> }}

        {{#if @data.timeTracking}}
          <tabs.Tab @label="Zeitaufteilung" as |state|>
            <TimeTrackingResults
              @data={{@data.timeTracking}}
              @playerApi={{this.player}}
              @active={{state.active}}
            />
          </tabs.Tab>
        {{/if}}

        <tabs.Tab @label="Tricks">
          <TricksStub />
        </tabs.Tab>

        {{#if @data.artistic}}
          <tabs.Tab @label="Artistik">
            <ArtisticResults @data={{@data.artistic}} />
          </tabs.Tab>
        {{/if}}

        {{#if @data.notTodoList}}
          <tabs.Tab @label="Not Todo List">
            <NotTodoListResults @data={{@data.notTodoList}} />
          </tabs.Tab>
        {{/if}}
      </Tabs>

      {{#if @editLink}}
        <Button @push={{@editLink}}>Bearbeiten</Button>
      {{/if}}
    </div>
  </template>
}
