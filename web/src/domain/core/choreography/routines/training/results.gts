import { YoutubePlayer } from '../../../../supporting/youtube';
import { scoreArtistic } from '../artistic/actions';
import { loadSystem, loadSystemDescriptor } from '../systems/actions';
import { ArtisticTrainingResults } from './artistic/results';

import type { WireArtisticResults } from '../artistic/domain-objects';
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
