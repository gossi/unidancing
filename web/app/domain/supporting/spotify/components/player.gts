import Component from '@glimmer/component';
import { fn } from '@ember/helper';

import { command } from 'ember-command';
import { service } from 'ember-polaris-service';
import { and, not } from 'ember-truth-helpers';

import { Button, Icon, IconButton, Popover, popover } from '@hokulea/ember';

import { device2Icon, formatArtists } from '../helpers';
import { SpotifyService } from '../service';
import { LoginWithSpotify } from './login-with-spotify';
import styles from './player.css';

import type { Device } from '../domain-objects';

export class SpotifyPlayer extends Component {
  @service(SpotifyService) declare spotify: SpotifyService;

  get client() {
    return this.spotify.client;
  }

  get track() {
    return this.client.track;
  }

  get otherDevices() {
    return this.client.devices.filter((dev) => dev.id !== this.client.device?.id);
  }

  selectDevice = async (device: Device) => {
    await this.client.selectDevice(device);
  };

  <template>
    <div class={{styles.layout}}>
      <div class={{styles.content}}>
        <Icon @icon="spotify-logo" @style="fill" class={{styles.spotify}} />

        {{#if (and this.client.authenticated (not this.client.error))}}
          {{!-- {{#if this.client.ready}}
            <p>
              {{#if this.track}}
                <strong>{{this.track.name}}</strong><br />
                <small>{{formatArtists this.track.artists}}</small>
              {{/if}}
            </p>
            {{!-- {{else if this.client.error}}
            <p>
              <Icon @icon="warning" @style="fill" class={{styles.warning}} />
              Fehler:
              {{this.client.error}}
            </p> --}
          {{/if}} --}}

          {{#if this.client.device}}
            <p>
              {{#if this.track}}
                <strong>{{this.track.name}}</strong><br />
                <small>{{formatArtists this.track.artists}}</small>
              {{/if}}
            </p>
            {{!-- {{else if this.client.error}}
            <p>
              <Icon @icon="warning" @style="fill" class={{styles.warning}} />
              Fehler:
              {{this.client.error}}
            </p> --}}
          {{else}}
            <p>
              <Icon @icon="warning" @style="fill" class={{styles.warning}} />
              Bitte Player auswählen
              <Icon @icon="arrow-right" @style="thin" />
            </p>
          {{/if}}
        {{else}}
          <div><LoginWithSpotify /></div>
        {{/if}}
      </div>

      <div>
        {{#if this.client.authenticated}}
          {{#let (popover opened=this.client.loadDevices.perform) as |pop|}}
            <IconButton
              @icon="devices"
              @iconStyle="bold"
              @importance="plain"
              @label="Spotify Player auswählen"
              class={{styles.trigger}}
              data-has-device={{if this.client.device true}}
              data-need-device={{not this.client.device}}
              {{pop.trigger}}
            />

            <Popover {{pop.target}} class={{styles.devices}}>
              <b>Spotify Player</b>

              {{#if this.client.device}}
                <div class={{styles.device}}>
                  <p>Aktueller Player</p>

                  <p>
                    <Icon @icon={{device2Icon this.client.device.type}} />
                    {{this.client.device.name}}
                  </p>
                </div>
              {{/if}}

              {{#if this.otherDevices}}
                <div>
                  <p>Anderen Player wählen</p>

                  {{#each this.otherDevices as |device|}}
                    <Button
                      @push={{command (fn this.selectDevice device) pop.close}}
                      @importance="plain"
                    >
                      <:before><Icon @icon={{device2Icon device.type}} /></:before>
                      <:label>{{device.name}}</:label>
                    </Button>
                  {{/each}}
                </div>
              {{/if}}
            </Popover>
          {{/let}}
        {{/if}}
      </div>
    </div>
  </template>
}
