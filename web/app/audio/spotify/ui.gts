import Component from '@glimmer/component';
import styles from './ui.css';
import { service, Registry as Services } from '@ember/service';
import { formatArtists } from '../../utils/spotify';
import { on } from '@ember/modifier';
import { action } from '@ember/object';
import SpotifyPlayer from './player';
import LoginWithSpotify from '../../components/login-with-spotify';
import pick from 'ember-composable-helpers/helpers/pick';
import Icon, {Icons} from '../../components/icon';

function device2Icon(device: string) {
  return device.toLowerCase() as Icons;
}

export default class SpotifyPlayerComponent extends Component {
  @service declare spotify: Services['spotify'];
  @service('player') declare playerService: Services['player'];

  get client() {
    return this.spotify.client;
  }

  get track() {
    return this.client.track?.data;
  }

  @action
  async selectDevice(device: SpotifyApi.UserDevice) {
    await this.client.selectDevice(device);
  }

  <template>
    {{#if this.client.authenticated}}
      <div class={{styles.layout}}>
        <p>
          {{log 'player UI track' this.track}}
          {{#if this.track}}
            <strong>{{this.track.name}}</strong><br>
            <small>{{formatArtists this.track.artists}}</small>
          {{/if}}
        </p>

        <button type="button" {{on "click" this.spotify.client.toggle}} class={{styles.play}}>
          {{#if this.spotify.client.playing}}⏸️{{else}}▶️{{/if}}
        </button>

        {{log this.client}}

        <select {{on "change" (pick "target.value" this.selectDevice)}} class={{styles.devices}}>
          <option></option>
          {{#each this.client.devices as |device|}}
            <option selected={{device.is_active}} value={{device.id}}>
              <Icon @icon={{device2Icon device.type}}/>
              {{device.name}}
            </option>
          {{/each}}
        </select>

      </div>
    {{else}}
      <LoginWithSpotify />
    {{/if}}
  </template>
}
