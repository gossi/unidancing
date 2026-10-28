import Component from '@glimmer/component';

import { command } from 'ember-command';
import { service } from 'ember-polaris-service';

import IconSpotifyLogo from '~icons/custom/spotify-logo';
import IconArrowRightThin from '~icons/ph/arrow-right-thin';
import IconDevicesBold from '~icons/ph/devices-bold';
import IconWarningFill from '~icons/ph/warning-fill';

import { Button, Icon, IconButton, Popover, popover } from '@hokulea/ember';

import { device2Icon, formatArtists } from '../helpers';
import { SpotifyService } from '../service';
import { LoginWithSpotify } from './login-with-spotify';

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
    <div class="layout">
      <div class="content">
        <Icon @icon={{IconSpotifyLogo}} class="spotify" />

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
              <Icon @icon={{IconWarningFill}} class="warning" />
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
              <Icon @icon={{IconWarningFill}} class="warning" />
              Fehler:
              {{this.client.error}}
            </p> --}}
          {{else}}
            <p>
              <Icon @icon={{IconWarningFill}} class="warning" />
              Bitte Player auswählen
              <Icon @icon={{IconArrowRightThin}} />
            </p>
          {{/if}}
        {{else}}
          <div><LoginWithSpotify /></div>
        {{/if}}
      </div>

      <div>
        {{#if this.client.authenticated}}
          {{#let
            (popover opened=this.client.loadDevices.perform position="top span-left")
            as |pop|
          }}
            <IconButton
              @icon={{IconDevicesBold}}
              @importance="plain"
              @label="Spotify Player auswählen"
              class="trigger"
              data-has-device={{if this.client.device true}}
              data-need-device={{not this.client.device}}
              {{pop.trigger}}
            />

            <Popover {{pop.target}} class="devices">
              <b>Spotify Player</b>

              {{#if this.client.device}}
                <div class="device">
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
    <style scoped>
      .layout {
        display: flex;
        align-items: center;
        justify-content: space-between;

        min-height: calc(4.5rem + 1vw);
        padding: var(--spacing-container-4);

        strong,
        small {
          text-overflow: ellipsis;
        }
      }

      .content {
        display: flex;
        gap: 1rem;
        align-items: center;
      }

      .warning {
        color: var(--indicator-warning-plain-text);
      }

      .spotify {
        font-size: var(--s4);
        color: #1ed760;
      }

      .trigger {
        padding: var(--spacing-primitive-4);
        font-size: var(--s3);

        &[data-need-device] {
          color: var(--indicator-error-plain-text);
        }

        &[data-has-device] {
          /* spotify green */
          color: #1ed760;
        }
      }

      .device {
        width: 100%;
        padding-block: var(--spacing-primitive-4);
        padding-inline: var(--spacing-primitive-4);
        border-radius: var(--shape-radius-primitive);

        background-color: var(--surface-container1);

        p:first-child {
          color: var(--typography-muted);
        }

        p:nth-child(2) {
          padding-block: var(--spacing-primitive-1);
          font-size: var(--s0);
          font-weight: 550;
        }
      }

      .devices {
        div {
          display: flex;
          flex-direction: column;
          align-items: flex-start;

          :where(p:first-child) {
            color: var(--typography-subtle);
          }
        }

        &:popover-open {
          /* position: absolute;
          inset: auto var(--spacing-container-1) 5rem auto; */

          display: flex;
          flex-direction: column;
          gap: var(--spacing-container-1);
          margin-right: var(--spacing-container-1);

          button {
            justify-content: flex-start;
            padding-inline: var(--spacing-primitive-4);

            span:first-child {
              font-size: var(--s1);
            }
          }

          @media (width >= 72rem) {
            /* left: calc(50% + var(--sizing-max-content-width) / 2); */
            right: calc((100% - var(--sizing-max-content-width)) / 2);
          }
        }
      }
    </style>
  </template>
}
