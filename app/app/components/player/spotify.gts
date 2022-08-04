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
import LoginWithSpotify from '../login-with-spotify';
import pick from 'ember-composable-helpers/helpers/pick';
import Icon, {Icons} from '../icon';

function device2Icon(device: string) {
  return device.toLowerCase() as Icons;
}

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
  selectDevice(id: string) {
    this.spotify.client.transferMyPlayback([id]);
  }

  @action
  async loadPlayer() {
    await this.player.load();
    this.devices = (await this.spotify.client.getMyDevices()).devices;

    const activeDevice = this.devices.find(device => device.is_active);

    if (!this.player.playing && !activeDevice && this.devices.length === 1) {
      this.selectDevice(this.devices[0].id as string);
    }
  }

  <template>
    {{#if this.spotify.authed}}
      <div {{didInsert this.loadPlayer}} class={{styles.layout}}>
        <p>
          {{#if this.track}}
            <strong>{{this.track.name}}</strong><br>
            <small>{{formatArtists this.track.artists}}</small>
          {{/if}}
        </p>


          <button type="button" {{on "click" this.player.toggle}} class={{styles.play}}>
            {{#if this.player.playing}}⏸️{{else}}▶️{{/if}}
          </button>



          <select {{on "change" (pick "target.value" this.selectDevice)}} class={{styles.devices}}>
            <option></option>
            {{#each this.devices as |device|}}
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
