import { compressToEncodedURIComponent } from 'lz-string';

import type { TrainingTest } from '../training/domain-objects';
import type { ArtisticResults, WireArtisticResults } from './artistic/domain-objects';
import type { TimeAnalysis, TimeTracking } from './time-tracking/domain';
import type RouterService from '@ember/routing/router-service';

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

export function canUseForTraining(routine: RoutineResult) {
  return routine.artistic;
}

export function makeTrainingData(result: RoutineResult): TrainingTest {
  return {
    rider: result.rider,
    type: result.type,
    event: result.event ?? '',
    date: result.date,
    video: result.video,
    reference: result.artistic as ArtisticResults
  };
}

export function makeTrainingLink(routine: RoutineResult, router: RouterService) {
  try {
    const data = makeTrainingData(routine);
    const qs = compressToEncodedURIComponent(JSON.stringify(data));
    const path = router.urlFor('choreography.routines.training', qs);

    return `${window.location.origin}${path}`;
  } catch {
    return '';
  }
}
