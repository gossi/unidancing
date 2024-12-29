import type { JudgingSystemResults, WireJudgingSystemResults } from './artistic/domain-objects';
import type { TimeAnalysis, TimeTracking } from './timeline/domain';

export interface RoutineTest {
  rider: string;
  event?: string;
  date?: string;
  video?: string;
  timeTracking?: TimeTracking;
  artistic?: WireJudgingSystemResults;
}

export interface RoutineResult {
  rider: string;
  event?: string;
  date?: string;
  video?: string;
  timeTracking?: TimeAnalysis;
  artistic?: JudgingSystemResults;
}
