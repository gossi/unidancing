import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { fn, hash } from '@ember/helper';
import { on } from '@ember/modifier';

import { Form } from '@hokulea/ember';

import { PlaylistsResource } from '../resources/playlists';
import styles from './playlist-chooser.css';

import type { Playlist } from '../domain-objects';

export interface PlaylistChooserSignature {
  Args: {
    select: (selection: Playlist) => void;
  };
}

export class PlaylistChooser extends Component<PlaylistChooserSignature> {
  resource = PlaylistsResource.from(this);

  select = (data: { selection: Playlist }) => {
    this.args.select(data.selection);
  };

  <template>
    <Form @data={{hash selection=undefined}} @submit={{this.select}} class={{styles.form}} as |f|>
      <f.List @name="selection" @label="Playlist auswählen" as |l|>
        {{#each this.resource.playlists as |playlist|}}
          <l.Option @value={{playlist}}>{{playlist.name}}</l.Option>
        {{/each}}
      </f.List>

      <f.Submit>Auswählen</f.Submit>
    </Form>

    {{!-- <div class={{styles.select}}>
      <h1>Playlist auswählen</h1>

      <ul class={{styles.playlist}}>
        {{#each this.resource.playlists as |playlist|}}
          <li {{on "click" (fn this.select playlist)}}>
            {{playlist.name}}
          </li>
        {{/each}}
      </ul>

      <button type="button" {{on "click" (fn @select this.selection)}}>Select</button>
    </div> --}}
  </template>
}
