import Component from '@glimmer/component';
import { PlaylistResource } from 'dance-oh-mat/resources/spotify/playlist';
import { tracked } from '@glimmer/tracking';

export default class GameComponent extends Component {
  @tracked token?: string;

  danceList = PlaylistResource.from(this, () => ({
    playlist: '3qaxO2Z99batsuhi12MDsn'
  }));
}
