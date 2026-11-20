import Component from '@glimmer/component';
import { getOwner } from '@ember/owner';

import { getStartForDancing, PlayTrack, playTrack } from '#support/spotify';

import type { ExerciseMediaSong } from '../../domain-objects';
import type Owner from '@ember/owner';
import type { Track } from '#support/spotify';

interface SongSignature {
  Args: {
    media: ExerciseMediaSong;
  };
}

export class Song extends Component<SongSignature> {
  playTrack = playTrack(getOwner(this) as Owner);

  play = async (track: Track) => {
    const start =
      this.args.media.play === 'dance'
        ? getStartForDancing(track)
        : this.args.media.play === 'custom' && this.args.media.start
          ? this.args.media.start * 1000
          : 0;

    await this.playTrack(track, start);
  };

  <template><PlayTrack @track={{@media.id}} @play={{this.play}} /></template>
}
