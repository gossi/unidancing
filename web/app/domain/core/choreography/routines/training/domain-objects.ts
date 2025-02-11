import type { WireArtisticResults } from '../analysis/artistic/domain-objects';

export interface TrainingTest {
  rider: string;
  type: 'individual' | 'pair' | 'small-group' | 'large-group';
  event: string;
  date?: string;
  video: string;
  reference: WireArtisticResults;
}

export interface TrainingResult {
  rider: string;
  type: 'individual' | 'pair' | 'small-group' | 'large-group';
  event: string;
  date?: string;
  video: string;
  reference: WireArtisticResults;
  result: WireArtisticResults;
}
