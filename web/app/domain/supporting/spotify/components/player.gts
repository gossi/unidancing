import Component from '@glimmer/component';
import styles from './player.css';
import { service } from 'ember-polaris-service';
import { formatArtists } from '../helpers';
import { on } from '@ember/modifier';
import { action } from '@ember/object';
import { LoginWithSpotify } from './login-with-spotify';
import pick from 'ember-composable-helpers/helpers/pick';
import { Icon } from '../../ui';
import type { Device } from '../domain-objects';
import { device2Icon } from '../helpers';
import { SpotifyService } from '../service';
import { eq } from 'ember-truth-helpers';

export class SpotifyPlayer extends Component {
  @service(SpotifyService) declare spotify: SpotifyService;

  get client() {
    return this.spotify.client;
  }

  get track() {
    return this.client.track?.data;
  }

  @action
  async selectDevice(deviceId: string) {
    const device = this.client.devices.find((dev) => dev.id === deviceId);
    await this.client.selectDevice(device as Device);
  }

  <template>
    {{#if this.client.authenticated}}
      <div class={{styles.layout}}>
        <p>
          {{#if this.track}}
            <strong>{{this.track.name}}</strong><br />
            <small>{{formatArtists this.track.artists}}</small>
          {{/if}}
        </p>

        <div class={{styles.devices}}>
          <select {{on 'change' (pick 'target.value' this.selectDevice)}}>
            <option>[Player auswählen]</option>
            {{#each this.client.devices as |device|}}
              <option selected={{eq device.id this.client.device.id}} value={{device.id}}>
                <Icon @icon={{device2Icon device.type}} />
                {{device.name}}
              </option>
            {{/each}}
          </select>
          <button type='button' class={{styles.reload}} {{on 'click' this.client.loadDevices}}><Icon
              @icon='reload'
            /></button>
        </div>
      </div>
    {{else}}
      <LoginWithSpotify />
    {{/if}}
  </template>
}
