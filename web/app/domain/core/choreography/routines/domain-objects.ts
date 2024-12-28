import type { WireJudgingSystemResults } from './artistic/domain-objects';

interface TimeTrack {
  from: number;
  to: number;
}

export interface RoutineTest {
  rider: string;
  event?: string;
  date?: string;
  video?: string;
  timeTracking?: {
    tricks: TimeTrack[];
    artistic: TimeTrack[];
    void: TimeTrack[];
    filler: TimeTrack[];
    faceup: TimeTrack[];
  };
  artistic?: WireJudgingSystemResults;
}
