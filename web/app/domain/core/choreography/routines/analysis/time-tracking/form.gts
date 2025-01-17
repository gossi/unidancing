import Component from '@glimmer/component';
import { LinkTo } from '@ember/routing';

import { type TimeTracking, type TimeTrackingFormData, validateTimeTracking } from './domain';
import { TimelineEditor } from './editor';
import styles from './timeline.css';

import type { YoutubePlayerAPI } from '../../../../../supporting/youtube';
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
        value: data,
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

      <h3>Anleitung</h3>

      <p>
        Die Zeitaufteilung misst wieviel Zeit mit Tricks, Artistik, Filler und Void (nichts)
        verbracht wird, genauer ist diese Methode in der
        <LinkTo @route="training.diagnostics.time-tracking">Trainingsdiagnostik</LinkTo>
        erklärt.
      </p>

      <p>
        Die Zeiterfassung funktioniert ähnlich einer Stoppuhr. Während die Kür läuft kann ein
        Merkmal gestartet werden und ein erneutes auslösen stoppt die Erfassung. Zum Auslösen den
        Text in der Tabelle oben drücken oder Tastenkürzel (siehe unten).<br />
        Für eine genaue Erfassung bietet es sich an ein Merkmal nach dem anderen zu stoppen und nach
        Abschluss mit dem nächsten weiter zu machen.
      </p>

      <p>
        Hilfreiche Tastenkürzel:
      </p>

      <table class={{styles.shortcuts}}>
        <thead>
          <tr>
            <th>Kürzel</th>
            <th>Video</th>
            <th>Kürzel</th>
            <th>Tagging</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><kbd>space/leertaste</kbd></td>
            <td>play / pause</td>
            <td><kbd>a</kbd></td>
            <td>Artistik</td>
          </tr>
          <tr>
            <td><kbd>← / →</kbd></td>
            <td>± 0.1s</td>
            <td><kbd>c</kbd></td>
            <td>Kommunikation</td>
          </tr>
          <tr>
            <td><kbd>Alt/Option</kbd> + <kbd>← / →</kbd></td>
            <td>± 0.25s</td>
            <td><kbd>t</kbd></td>
            <td>Tricks</td>
          </tr>
          <tr>
            <td><kbd>Ctrl</kbd> + <kbd>← / →</kbd></td>
            <td>± 1s</td>
            <td><kbd>f</kbd></td>
            <td>Filler</td>
          </tr>
          <tr>
            <td><kbd>Shift</kbd> + <kbd>← / →</kbd></td>
            <td>± 10s</td>
            <td><kbd>v</kbd></td>
            <td>Void</td>
          </tr>
          <tr>
            <td></td>
            <td></td>
            <td><kbd>s</kbd></td>
            <td>start / stop</td>
          </tr>
        </tbody>
      </table>
    {{/let}}
  </template>
}
