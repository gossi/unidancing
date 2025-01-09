import Component from '@glimmer/component';

import { TimelineViewer } from './viewer';

import type { YoutubePlayerAPI } from '../../../../supporting/youtube';
import type { TimeAnalysis } from './domain';

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
  </template>
}
