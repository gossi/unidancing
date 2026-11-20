import Component from '@glimmer/component';

import { TimeTrackingSummary } from './evaluation';
import { TimelineViewer } from './viewer';

import type { TimeAnalysis } from './domain';
import type { YoutubePlayerAPI } from '#support/youtube';

interface TimeTrackingResultsSignature {
  Args: {
    active: boolean;
    data: TimeAnalysis;
    playerApi?: YoutubePlayerAPI;
  };
}

export class TimeTrackingResults extends Component<TimeTrackingResultsSignature> {
  declare player: YoutubePlayerAPI;

  <template>
    <TimelineViewer @active={{@active}} @playerApi={{@playerApi}} @data={{@data}} />

    <h3>Auswertung</h3>
    <TimeTrackingSummary @data={{@data}} />
  </template>
}
