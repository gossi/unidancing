import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';

import { Button, Form } from '@hokulea/ember';

import { YoutubePlayer } from '../../../../supporting/youtube';
import {
  ARTISTIC_FORM_DATA,
  ArtisticForm,
  // loadArtisticData,
  parseArtisticFormData
} from '../analysis/artistic/form';

import type { YoutubePlayerAPI } from '../../../../supporting/youtube';
import type { ArtisticFormData } from '../analysis/artistic/form';
import type { TrainingResult, TrainingTest } from './domain-objects';
import type Owner from '@ember/owner';

interface TrainingTesterFormArgs {
  data: TrainingTest;
  submit: (data: TrainingResult) => void;
}

export class TrainingTesterForm extends Component<{
  Args: TrainingTesterFormArgs;
}> {
  Form = Form<ArtisticFormData, void>;

  video: string;
  @tracked started = false;

  data: ArtisticFormData = {
    ...ARTISTIC_FORM_DATA
  };

  @tracked player?: YoutubePlayerAPI;

  setPlayerApi = (api: YoutubePlayerAPI) => {
    this.player = api;
  };

  constructor(owner: Owner, args: TrainingTesterFormArgs) {
    super(owner, args);

    this.video = args.data.video as string;
  }

  submit = (data: ArtisticFormData) => {
    const routine: TrainingResult = {
      ...this.args.data,
      result: parseArtisticFormData(data, this.args.data.reference.name)
    };

    this.args.submit(routine);
  };

  start = () => {
    this.started = true;
  };

  <template>
    {{#if this.started}}
      <YoutubePlayer @url={{this.video}} @setApi={{this.setPlayerApi}} />

      <this.Form @data={{this.data}} @submit={{this.submit}} as |f|>

        <ArtisticForm @form={{f}} @systemID={{@data.reference.name}} />

        <f.Submit>Ergebnisse anzeigen</f.Submit>
      </this.Form>
    {{else}}
      <p>
        Du bist herausgefordert worden die Kür von
        {{@data.rider}}
        der
        {{@data.event}}
        zu bewerten.
      </p>

      <p>
        <Button @push={{this.start}}>Start</Button>
      </p>
    {{/if}}
  </template>
}
