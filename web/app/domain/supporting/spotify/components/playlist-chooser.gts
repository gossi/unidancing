import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';
import { action } from '@ember/object';

import { eq } from 'ember-truth-helpers';

import { PlaylistsResource } from '../resources/playlists';
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

