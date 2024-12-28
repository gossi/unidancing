import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';

import { tracked as deepTracked } from 'ember-deep-tracked';

import { Form, Tabs } from '@hokulea/ember';

import { YoutubePlayer } from '../../..//supporting/youtube';
import { extractArtisticWireData, loadSystem } from './artistic/actions';
import {
  ARTISTIC_FORM_DATA,
  ArtisticForm,
  loadArtisticData,
  parseArtisticFormData,
  updateArtisticData
} from './artistic/form';
import { IUF_PERFORMANCE_2019 } from './systems/iuf-performance-2019';
import { TimelineEditor } from './timeline/editor';

import type { YoutubePlayerAPI } from '../../..//supporting/youtube';
import type { JudgingSystem } from './artistic/domain-objects';
import type { ArtisticFormData } from './artistic/form';
import type { RoutineTest } from './domain-objects';
import type Owner from '@ember/owner';
import type { FormBuilder } from '@hokulea/ember';

interface Data extends ArtisticFormData {
  rider: string;
  event: string;
  video: string;
}

function asArtisticFormBuilder(f: FormBuilder<Data, void>) {
  return f as FormBuilder<ArtisticFormData, void>;
}

interface RoutineTesterFormArgs {
  data?: RoutineTest;
  submit: (data: RoutineTest) => void;
}

export class RoutineTesterForm extends Component<{
  Args: RoutineTesterFormArgs;
}> {
  Form = Form<Data, void>;

  video = 'https://www.youtube.com/watch?v=Y3al545mkR4';

  @deepTracked artistic: JudgingSystem;

  data: Data = {
    rider: '',
    event: '',
    video: '',
    ...ARTISTIC_FORM_DATA
  };

  @tracked player?: YoutubePlayerAPI;

  setPlayerApi = (api: YoutubePlayerAPI) => {
    this.player = api;
  };

  constructor(owner: Owner, args: RoutineTesterFormArgs) {
    super(owner, args);

    this.artistic = loadSystem(IUF_PERFORMANCE_2019, args.data?.artistic);

    if (args.data) {
      this.loadData(args.data);
    }
  }

  loadData(data: RoutineTest) {
    this.data.rider = data.rider;
    this.data.event = data.event as string;
    this.data.video = data.video as string;

    loadArtisticData(this.data, this.artistic);
  }

  updateJudgingSystemResults = (data: Data) => {
    updateArtisticData(data, this.artistic);

    return undefined;
  };

  submit = (data: Data) => {
    const artistic = extractArtisticWireData(parseArtisticFormData(this.artistic, data));
    const routine: RoutineTest = {
      rider: data.rider,
      event: data.event,
      video: data.video,
      artistic
    };

    this.args.submit(routine);
  };

  <template>
    {{#if this.video}}
      <YoutubePlayer @url={{this.video}} @setApi={{this.setPlayerApi}} />

      <this.Form
        @data={{this.data}}
        @validateOn="change"
        @validate={{this.updateJudgingSystemResults}}
        @submit={{this.submit}}
        as |f|
      >
        <Tabs as |tabs|>
          <tabs.Tab @label="Kür">
            <f.Text @name="rider" @label="Fahrer" />
            <f.Text @name="event" @label="Veranstaltung" />
            <f.Text @name="video" @label="Video" placeholder="YouTube URL" />
          </tabs.Tab>

          <tabs.Tab @label="Zeitaufteilung" as |state|>
            <TimelineEditor @playerApi={{this.player}} @active={{state.active}} />
          </tabs.Tab>

          <tabs.Tab @label="Artistik">
            <ArtisticForm @form={{asArtisticFormBuilder f}} @system={{this.artistic}} />
          </tabs.Tab>
        </Tabs>

        <f.Submit>Ergebnisse anzeigen</f.Submit>
      </this.Form>
    {{/if}}
  </template>
}
