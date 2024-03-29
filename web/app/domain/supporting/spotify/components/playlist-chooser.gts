import { action } from '@ember/object';
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { PlaylistsResource } from '../resources/playlists';
import { on } from '@ember/modifier';
import { eq } from 'ember-truth-helpers';
import { fn } from '@ember/helper';
import styles from './playlist-chooser.css';

export interface PlaylistChooserSignature {
  Args: {
    select: (selection: SpotifyApi.PlaylistObjectSimplified) => void
  }
}

export class PlaylistChooser extends Component<PlaylistChooserSignature> {
  @tracked selection?: SpotifyApi.PlaylistObjectSimplified;

  resource = PlaylistsResource.from(this);

  @action
  select(playlist: SpotifyApi.PlaylistObjectSimplified) {
    this.selection = playlist;
  }

  <template>
    <div class={{styles.select}}>
    <h1>Playlist auswählen</h1>

    <ul class={{styles.playlist}}>
      {{#each this.resource.playlists as |playlist|}}
        <li
          role="listitem"
          aria-selected={{eq playlist this.selection}}
          {{on "click" (fn this.select playlist)}}
        >
          {{playlist.name}}
        </li>
      {{/each}}
    </ul>

    <button type='button' {{on 'click' (fn @select this.selection)}}>Select</button>
    </div>
  </template>
}

