import Component from '@glimmer/component';
import { AudioPlayer, AudioService } from '../audio';
import {
  WithSpotify,
  SpotifyService,
  TrackResource,
  formatArtists
} from '../audio/spotify';
import type { Track } from '../audio/spotify';
import type { TOC } from '@ember/component/template-only';
import { createMachine } from "xstate";
import { useMachine, Statechart } from 'ember-statecharts';

export const Machine = createMachine(
  {
    id: "Dance-Oh-Mat",
    initial: "lobby",
    states: {
      lobby: {
        on: {
          help: {
            target: "manual",
          },
          play: {
            target: "playing",
          },
        },
      },
      manual: {
        on: {
          start: {
            target: "lobby",
          },
        },
      },
      playing: {
        initial: "selection",
        states: {
          selection: {
            on: {
              dance: {
                target: "dancing",
              },
            },
          },
          dancing: {
            on: {
              select: {
                target: "selection",
              },
            },
          },
        },
        on: {
          stop: {
            target: "lobby",
          },
        },
      },
    },
    schema: {
      events: {} as
        | { type: "play" }
        | { type: "help" }
        | { type: "start" }
        | { type: "stop" }
        | { type: "select" }
        | { type: "dance" },
    },
    predictableActionArguments: true,
    preserveActionOrder: true,
  },
  {
    actions: {},
    services: {},
    guards: {},
    delays: {},
  },
);

const Lobby: TOC<{}> = <template>
  Hier die Einstellungen
</template>

const Manual: TOC<{}> = <template>
  Anleitung
</template>

// selection song:
// https://open.spotify.com/intl-de/track/7IiurNiwebWtRFrMUojN04

class Game extends Component {
  machine = useMachine(this, () => ({
      machine: Machine
    })
  );

  <template>
    {{#if (this.machine.state.matches 'manual')}}
      <Manual />
    {{else if (this.machine.state.matches 'lobby')}}
      <Lobby />
    {{else if (this.machine.state.matches 'playing')}}
      playing
    {{/if}}
  </template>
}

const DanceOhMat: TOC<{}> = <template>
  <h1>Dance Oh! Mat</h1>

  <WithSpotify>
    <Game/>
  </WithSpotify>
</template>


export default DanceOhMat;
