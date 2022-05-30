import Component from '@glimmer/component';
import styles from './spotify.css';
import { service, Registry as Services } from '@ember/service';
import SpotifyService from '../../services/spotify';
import { formatArtists } from '../../utils/spotify';
import didInsert from '@ember/render-modifiers/modifiers/did-insert';
import { on } from '@ember/modifier';
import {action} from '@ember/object';
import {tracked} from '@glimmer/tracking';
import SpotifyPlayer from '../../player/spotify';

export default class SpotifyPlayerComponent extends Component {
  @service declare spotify: SpotifyService;
  @service('player') declare playerService: Services['player'];

  @tracked devices: SpotifyApi.UserDevice[] = [];

  get player(): SpotifyPlayer {
    return this.playerService.player as SpotifyPlayer;
  }

  get track() {
    return this.player.track?.data;
  }

  @action
  selectDevice(event: Event) {
    const id = (event.target as HTMLSelectElement).value;
    this.spotify.client.transferMyPlayback([id]);
  }

  @action
  async loadPlayer() {
    this.player.load();
    this.devices = (await this.spotify.client.getMyDevices()).devices;
  }

  <template>
    <div {{didInsert this.loadPlayer}} class="grid">
      <p>
        {{#if this.track}}
          <strong>{{this.track.name}}</strong><br>
          <small>{{formatArtists this.track.artists}}</small>
        {{/if}}
      </p>

      <div>
        <button type="button" {{on "click" this.player.toggle}}>
          {{#if this.player.playing}}Pause{{else}}Play{{/if}}
        </button>

      </div>

      <div>
        <select {{on "change" this.selectDevice}}>
          <option></option>
          {{#each this.devices as |device|}}
            <option selected={{device.is_active}} value={{device.id}}>{{device.type}} {{device.name}}</option>
          {{/each}}
        </select>
      </div>
    </div>
  </template>
}
