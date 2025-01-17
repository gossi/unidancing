import type { ArtisticResults, WireArtisticResults } from './artistic/domain-objects';
import type { TimeAnalysis, TimeTracking } from './time-tracking/domain';

export interface RoutineTest {
  rider: string;
  type: 'individual' | 'pair' | 'small-group' | 'large-group';
  event?: string;
  date?: string;
  video?: string;
  timeTracking?: TimeTracking;
  artistic?: WireArtisticResults;
  notTodoList?: string[];
}

export interface RoutineResult {
  rider: string;
  type: 'individual' | 'pair' | 'small-group' | 'large-group';
  event?: string;
  date?: string;
  video: string;
  timeTracking?: TimeAnalysis;
  artistic?: ArtisticResults;
  notTodoList?: string[];
}
