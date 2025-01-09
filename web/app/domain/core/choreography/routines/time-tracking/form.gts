import Component from '@glimmer/component';

import { type TimeTracking, type TimeTrackingFormData, validateTimeTracking } from './domain';
import { TimelineEditor } from './editor';

import type { YoutubePlayerAPI } from '../../../../supporting/youtube';
import type { FormBuilder } from '@hokulea/ember';

interface TimelineFormSignature {
  Args: {
    active: boolean;
    form: FormBuilder<TimeTrackingFormData, void>;
    playerApi?: YoutubePlayerAPI;
  };
}

export class TimelineForm extends Component<TimelineFormSignature> {
  validate = (data: TimeTracking) => {
    const validation = validateTimeTracking(data);

    if (validation) {
      return validation.map((err) => ({
        type: 'error',
        value: {},
        message: err
      }));
    }

    return undefined;
  };

  <template>
    {{#let @form as |form|}}
      <form.Field @name="timeTracking" @label="" @validate={{this.validate}} as |f|>
        <TimelineEditor
          @active={{@active}}
          @playerApi={{@playerApi}}
          @data={{f.value}}
          @update={{f.setValue}}
        />
      </form.Field>
    {{/let}}
  </template>
}
