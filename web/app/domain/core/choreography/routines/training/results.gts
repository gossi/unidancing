import { YoutubePlayer } from '../../../../supporting/youtube';
import { scoreArtistic } from '../analysis/artistic/actions';
import { ArtisticTrainingResults } from '../analysis/artistic/training-results';
import { loadSystem, loadSystemDescriptor } from '../analysis/systems/actions';

import type { WireArtisticResults } from '../analysis/artistic/domain-objects';
import type { TrainingResult } from './domain-objects';
import type { TOC } from '@ember/component/template-only';

interface TrainingResultsSignature {
  Args: {
    data: TrainingResult;
  };
}

function score(artistic: WireArtisticResults) {
  const system = loadSystem(loadSystemDescriptor(artistic.name));

  return scoreArtistic(system, artistic);
}

const TrainingResults: TOC<TrainingResultsSignature> = <template>
  <YoutubePlayer @url={{@data.video}} />

  <ArtisticTrainingResults @data={{score @data.result}} @reference={{score @data.reference}} />
</template>;

export default TrainingResults;
