import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { hash } from '@ember/helper';
import { fn } from '@ember/helper';

import { Button, Form, Icon, Tabs } from '@hokulea/ember';

import { YoutubePlayer } from '../../../../supporting/youtube';
import {
  ARTISTIC_FORM_DATA,
  ArtisticForm,
  loadArtisticData,
  parseArtisticFormData
} from './artistic/form';
import styles from './form.css';
import { NOT_TODO_LIST_FORM_DATA, type NotTodoListFormData } from './not-todo-list/domain';
import { NotTodeListForm } from './not-todo-list/form';
import { TimelineForm } from './time-tracking/form';
import { TricksStub } from './tricks/stub';

import type { YoutubePlayerAPI } from '../../../../supporting/youtube';
import type { ArtisticFormData } from './artistic/form';
import type { RoutineTest } from './domain-objects';
import type { JudgingSystemID } from './systems/domain-objects';
import type { TimeTracking, TimeTrackingFormData } from './time-tracking/domain';
import type Owner from '@ember/owner';
import type { FormBuilder } from '@hokulea/ember';

interface Data extends ArtisticFormData, TimeTrackingFormData, NotTodoListFormData {
  rider: string;
  type: 'individual' | 'pair' | 'small-group' | 'large-group';
  date: string;
  event: string;
}

function asArtisticFormBuilder(f: FormBuilder<Data, void>) {
  return f as FormBuilder<ArtisticFormData, void>;
}

function asTimeTrackingFormBuilder(f: FormBuilder<Data, void>) {
  return f as FormBuilder<TimeTrackingFormData, void>;
}

function asNotTodoListFormBuilder(f: FormBuilder<Data, void>) {
  return f as FormBuilder<NotTodoListFormData, void>;
}

function includes(haystack: Record<string, unknown> | unknown[], needle: unknown) {
  return (Array.isArray(haystack) ? haystack : Object.keys(haystack)).includes(needle);
}

interface RoutineTesterFormArgs {
  data?: RoutineTest;
  submit: (data: RoutineTest) => void;
}

export class RoutineTesterForm extends Component<{
  Args: RoutineTesterFormArgs;
}> {
  Form = Form<Data, void>;

  artisticSystemID: JudgingSystemID = 'iuf-performance-2019';

  @tracked video?: string; // https://www.youtube.com/watch?v=Y3al545mkR4

  data: Data = {
    rider: '',
    event: '',
    date: '',
    type: 'individual',
    timeTracking: {
      // groups: {
      //   artistry: [
      //     [50, 80],
      //     [100, 110]
      //   ],
      //   tricks: [
      //     [120, 140],
      //     [150, 160]
      //   ]
      // }
    },
    ...ARTISTIC_FORM_DATA,
    ...NOT_TODO_LIST_FORM_DATA
  };

  @tracked timeTracking: TimeTracking = {};
  @tracked player?: YoutubePlayerAPI;

  setPlayerApi = (api: YoutubePlayerAPI) => {
    this.player = api;
  };

  constructor(owner: Owner, args: RoutineTesterFormArgs) {
    super(owner, args);

    if (args.data) {
      this.loadData(args.data);
    }
  }

  loadData(data: RoutineTest) {
    this.video = data.video as string;

    this.data.rider = data.rider;
    this.data.event = data.event as string;
    this.data.timeTracking = data.timeTracking ?? {};
    this.data['not-todo-list'] = data.notTodoList ?? [];

    if (data.artistic) {
      const artistic = loadArtisticData(data.artistic);

      this.data = {
        ...this.data,
        ...artistic
      };
    }
  }

  updateTimeTracking = (tracking: TimeTracking) => {
    this.timeTracking = tracking;
  };

  submit = (data: Data) => {
    const routine: RoutineTest = {
      rider: data.rider,
      type: data.type,
      date: data.date,
      event: data.event,
      video: this.video
    };

    if (Object.keys(data.timeTracking).length > 0) {
      routine.timeTracking = data.timeTracking;
    }

    // when artistic is present
    if (
      Object.entries(data)
        .filter(([k]) => k.startsWith('artistic-'))
        .some(([, v]) => v !== 0)
    ) {
      routine.artistic = parseArtisticFormData(data, this.artisticSystemID);
    }

    if (data['not-todo-list'].length > 0) {
      routine.notTodoList = data['not-todo-list'];
    }

    this.args.submit(routine);
  };

  startSample = (video: string) => {
    this.video = video;
  };

  start = (data: { video: string }) => {
    this.video = data.video;
  };

  <template>
    {{#if this.video}}
      <YoutubePlayer @url={{this.video}} @setApi={{this.setPlayerApi}} />

      <this.Form @data={{this.data}} @submit={{this.submit}} class={{styles.tabs}} as |f|>
        <Tabs as |tabs|>
          <tabs.Tab @label="Kür">
            <f.Text @name="rider" @label="Fahrer" />
            <f.Select @name="type" @label="Kür" as |s|>
              <s.Option @value="individual">Einzelkür</s.Option>
              <s.Option @value="pair">Paarkür</s.Option>
              <s.Option @value="small-group">Kleingruppe</s.Option>
              <s.Option @value="large-group">Großgruppe</s.Option>
            </f.Select>
            <f.Date @name="date" @label="Datum" />
            <f.Text @name="event" @label="Veranstaltung" />
          </tabs.Tab>

          <tabs.Tab @value="time">
            <:label>
              {{#if f.rawErrors}}
                {{#if (includes f.rawErrors "timeTracking")}}
                  <Icon @icon="warning" @style="fill" />
                {{/if}}
              {{/if}}
              Zeitaufteilung
            </:label>
            <:content as |state|>
              <TimelineForm
                @playerApi={{this.player}}
                @form={{asTimeTrackingFormBuilder f}}
                @active={{state.active}}
              />
            </:content>
          </tabs.Tab>

          <tabs.Tab @label="Tricks">
            <TricksStub />
          </tabs.Tab>

          <tabs.Tab @label="Artistik">
            <ArtisticForm
              @form={{asArtisticFormBuilder f}}
              @systemID={{this.artisticSystemID}}
              @results={{@data.artistic}}
            />
          </tabs.Tab>

          <tabs.Tab @label="Not Todo List">
            <NotTodeListForm @form={{asNotTodoListFormBuilder f}} />
          </tabs.Tab>
        </Tabs>

        <f.Submit>Ergebnisse anzeigen</f.Submit>
      </this.Form>
    {{else}}
      <p>
        Zum starten brauchst du ein Youtube Video einer Kür.<br />
        Am besten schaust du ins
        <a
          href="https://www.youtube.com/@KonstantinHoehne"
          target="_blank"
          rel="noopener noreferrer"
        >Youtube Video Archiv von Konstantin Höhne</a>.
      </p>

      <Form @data={{hash video=""}} @submit={{this.start}} as |f|>
        <f.Text
          @name="video"
          @label="Video"
          placeholder="https://www.youtube.com/watch?v=...."
          required
        />
        <f.Submit>Analyse starten</f.Submit>
      </Form>

      <h3>Beispiele</h3>

      <p>Zum Testen eine der Beispielküren nutzen:</p>

      <p>
        <Button
          @importance="subtle"
          @push={{fn this.startSample "https://www.youtube.com/watch?v=Y3al545mkR4"}}
        >Kazuhiro Shimoyama @ Unicon 16</Button>
        <Button
          @importance="subtle"
          @push={{fn this.startSample "https://www.youtube.com/watch?v=mSJftCOsnXw"}}
        >Anouk Rückert @ Unicon 21</Button>
      </p>
    {{/if}}
  </template>
}
