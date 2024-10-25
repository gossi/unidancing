import Component from '@glimmer/component';

import { use } from 'ember-resources';

import { Form } from '@hokulea/ember';

import { loadPlaylists } from '../resources/playlists';
import styles from './playlist-chooser.css';

import type { UserPlaylist } from '../domain-objects';

export interface PlaylistChooserSignature {
  Args: {
    select: (selection: UserPlaylist) => void;
  };
}

export class PlaylistChooser extends Component<PlaylistChooserSignature> {
  resource = use(this, loadPlaylists());

  get playlists() {
    return this.resource.current;
  }

  select = (data: { selection: UserPlaylist }) => {
    this.args.select(data.selection);
  };

  data: {
    selection?: UserPlaylist;
  } = {
    selection: undefined
  };

  <template>
    <Form @data={{this.data}} @submit={{this.select}} class={{styles.form}} as |f|>
      <f.List @name="selection" @label="Playlist auswählen" as |l|>
        {{log this.resource this.playlists}}
        {{#each this.playlists as |playlist|}}
          <l.Option @value={{playlist}}>{{playlist.name}}</l.Option>
        {{/each}}
      </f.List>

      <f.Submit>Auswählen</f.Submit>
    </Form>
  </template>
}
