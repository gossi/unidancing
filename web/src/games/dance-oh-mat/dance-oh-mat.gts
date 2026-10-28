import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { registerDestructor } from '@ember/destroyable';
import { getOwner } from '@ember/owner';
import { service } from '@ember/service';

import { getTracks } from '@unidancing/app/domain/supporting/spotify/resources/playlist';
import { dropTask, timeout } from 'ember-concurrency';
import { service as polarisService } from 'ember-polaris-service';
import { use } from 'ember-resources';
import Portal from 'ember-stargate/components/portal';
import PortalTarget from 'ember-stargate/components/portal-target';
import { assertEvent, assign, setup } from 'xstate';

import IconPauseFill from '~icons/ph/pause-fill';
import IconPlayFill from '~icons/ph/play-fill';
import IconQuestion from '~icons/ph/question';

import { Button, Form, IconButton } from '@hokulea/ember';

import { AudioPlayer, AudioService, playSound } from '../../../supporting/audio';
import {
  getRandomTrack,
  loadPlaylist,
  MaybeSpotifyPlayerWarning,
  playTrack,
  playTrackForDancing,
  SpotifyPlayButton,
  SpotifyService,
  WithSpotify
} from '../../../supporting/spotify';
import { useMachine } from '../../../supporting/statechart';

import type { Playlist, SpotifyClient, Track } from '../../../supporting/spotify';
import type { TOC } from '@ember/component/template-only';
import type Owner from '@ember/owner';
import type RouterService from '@ember/routing/router-service';

export enum DanceOhMatParam {
  Rounds = 'rounds',
  Duration = 'duration'
}

export interface DanceOhMatParams {
  [DanceOhMatParam.Rounds]?: number;
  [DanceOhMatParam.Duration]?: number;
}

type GameParams = Required<
  Pick<DanceOhMatParams, DanceOhMatParam.Rounds | DanceOhMatParam.Duration>
>;

const DEFAULTS = {
  [DanceOhMatParam.Rounds]: 4,
  [DanceOhMatParam.Duration]: 30
};

const getParam =
  <A extends DanceOhMatParams>(args: A, router: RouterService) =>
  <P extends DanceOhMatParam>(param: P): A[P] => {
    // NB: `Object.hasOwn(args, param)` throws here — `this.args` is Glimmer's
    // NamedArgsProxy and has no real property descriptors. Keep truthy check.
    if (args[param]) {
      return args[param];
    }

    if (router.currentRoute?.queryParams[param]) {
      return router.currentRoute.queryParams[param] as A[P];
    }

    return DEFAULTS[param];
  };

type Context = { rounds: number; duration: number; roundsToGo: number };

type GameEvent =
  // eslint-disable-next-line unicorn/prefer-type-literal-last
  | ({ type: 'play' } & GameParams)
  | { type: 'help' }
  | { type: 'dance'; track: Track }
  | { type: 'start' }
  | { type: 'finish' }
  | { type: 'stop' };

const Machine = setup({
  types: {
    events: {} as GameEvent,
    context: {} as Context
  },
  // Stubs that the `Game` component replaces through `Machine.provide()` —
  // v4 declared these as second-argument implementations.
  actions: {
    /* eslint-disable @typescript-eslint/no-empty-function */
    select: () => {},
    dance: () => {},
    play: () => {},
    finish: () => {},
    finishRound: () => {}
    /* eslint-enable @typescript-eslint/no-empty-function */
  },
  guards: {
    isGameOver: () => false
  }
}).createMachine({
  context: {
    ...DEFAULTS,
    roundsToGo: 0
  },
  id: 'Dance-Oh-Mat',
  initial: 'lobby',
  states: {
    lobby: {
      on: {
        help: {
          target: 'manual'
        },
        play: {
          target: 'playing',
          actions: {
            type: 'play'
          }
        }
      }
    },
    manual: {
      on: {
        start: {
          target: 'lobby'
        }
      }
    },
    playing: {
      initial: 'selection',
      states: {
        selection: {
          entry: {
            type: 'select'
          },
          on: {
            dance: {
              target: 'dancing'
            }
          }
        },
        dancing: {
          entry: {
            type: 'dance'
          },
          on: {
            finish: [
              {
                target: '#Dance-Oh-Mat.lobby',
                guard: 'isGameOver',
                actions: {
                  type: 'finish'
                }
              },
              {
                target: 'selection',
                actions: {
                  type: 'finishRound'
                }
              }
            ]
          }
        }
      },
      on: {
        stop: {
          target: 'lobby'
        }
      }
    }
  }
});

const LOBBY_TRACK_URI = 'spotify:track:7IiurNiwebWtRFrMUojN04';

const playLobby = async (client: SpotifyClient) => {
  await client.play({
    uris: [LOBBY_TRACK_URI]
  });
};

interface LobbySignature {
  Args: Partial<GameParams> & {
    play: (params: GameParams) => void;
  };
}

class Lobby extends Component<LobbySignature> {
  @service declare router: RouterService;

  get getParam() {
    return getParam(this.args, this.router);
  }

  get params() {
    return {
      duration: this.getParam(DanceOhMatParam.Duration),
      rounds: this.getParam(DanceOhMatParam.Rounds)
    };
  }

  <template>
    <Form @data={{this.params}} @submit={{@play}} as |f|>
      <f.Number @name="duration" @label="Dauer pro Lied [sec]" />
      <f.Number @name="rounds" @label="Runden [Anzahl]" />

      <MaybeSpotifyPlayerWarning />

      <SpotifyPlayButton type="submit">Start</SpotifyPlayButton>
    </Form>
  </template>
}

class Manual extends Component {
  @polarisService(SpotifyService) declare spotify: SpotifyService;
  @polarisService(AudioService) declare audio: AudioService;

  togglePlay = async () => {
    if (this.spotify.client.playing) {
      await this.spotify.client.pause();
    } else {
      await playLobby(this.spotify.client);
    }
  };

  <template>
    <h2>Anleitung</h2>

    <ol class="manual">
      <li>Es werden vier Runden gespielt, jede Runde wird zu einem Song getanzt.</li>
      <li>Die Runde beginnt:
        <ul>
          <li>
            Musik zur Song Auswahl:
            <IconButton
              @icon={{if this.spotify.client.playing IconPauseFill IconPlayFill}}
              @push={{this.togglePlay}}
              @label="Lobby Musik an/aus"
              @spacing="-1"
            />
          </li>
          <li>Die Auswahl dauert 5 Sekunden, der Countdown start</li>
          <li>
            Auswahl aus 4 Songs:<br />
            3x Chance auf "Tanzbaren Song"<br />
            1x Chance auf "Überraschung"
          </li>
        </ul>
      </li>

      <li>
        Songauswahl eingeben

        <Button @spacing="-1" @push={{fn (playSound) "select"}}>
          Eingabe
        </Button>
      </li>
      <li>
        Ohne Songauswahl:
        <br />75% Chance auf Überraschung
      </li>
      <li>
        Die Runde startet mit<br />

        <Button @spacing="-1" @push={{fn (playSound) "countDown"}}>
          Tanzbarer Song
        </Button>

        <Button @spacing="-1" @push={{fn (playSound) "surprise"}}>
          Überraschung
        </Button>
      </li>
      <li><i>Dance!</i></li>
    </ol>

    <style scoped>
      .manual {
        padding-inline-start: 1.25em;

        > li + li {
          margin-block-start: var(--spacing-primitive-1);
        }

        ul {
          padding-inline-start: 1em;
        }
      }

      .manual button {
        display: inline;
        width: unset;
        padding: 0.25em 0.5em;
      }
    </style>
  </template>
}

/*
 * Returns a weighted random
 *
 * @see https://stackoverflow.com/a/57130749/483492
 *
 * @example
 *
 * Call as:
 *
 * ```ts
 * const rand = random([0.75, 0.25]);
 * ```
 *
 * And `rand` will be `0` for (0.75) or `1` for (0.25)
 */
function random(pmf: number[]) {
  const cdf = pmf.map(
    (
      (sum) => (value) =>
        (sum += value)
    )(0)
  );
  const rand = Math.random();

  return cdf.findIndex((el) => rand <= el);
}

const PLAYLISTS: Record<string, string> = {
  epic: '3qaxO2Z99batsuhi12MDsn',
  surprise: '7FDu1kevbWvjA2dC9KNkWW'
};

// selection song:
// https://open.spotify.com/intl-de/track/7IiurNiwebWtRFrMUojN04

class Game extends Component {
  @polarisService(SpotifyService) declare spotify: SpotifyService;
  @polarisService(AudioService) declare audio: AudioService;

  @tracked counter?: number;
  song?: number;

  //  PlaylistResource.from(this, () => ({ playlist: PLAYLISTS.epic }))
  // surprisePlaylist = PlaylistResource.from(this, () => ({ playlist: PLAYLISTS.surprise }));
  // @ts-expect-error jaja, whatever
  dancePlaylistResource = use(this, loadPlaylist(PLAYLISTS.epic));
  // @ts-expect-error jaja, whatever
  surprisePlaylistResource = use(this, loadPlaylist(PLAYLISTS.surprise));

  get dancePlaylist() {
    return this.dancePlaylistResource.current;
  }

  get surprisePlaylist() {
    return this.surprisePlaylistResource.current;
  }

  //
  // Boot
  //
  constructor(owner: Owner, args: object) {
    super(owner, args);

    this.audio.player = AudioPlayer.Spotify;

    // load resources
    // this.dancePlaylist.load();
    // this.surprisePlaylist.load();

    // load resources
    // @ts-expect-error well, the "unused" is still the loading
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    const { dancePlaylist, surprisePlaylist } = this;

    registerDestructor(this, () => {
      this.audio.player = undefined;
    });
  }

  playSound = playSound(getOwner(this) as Owner);
  playTrack = playTrack(getOwner(this) as Owner);
  playTrackForDancing = playTrackForDancing(getOwner(this) as Owner);

  toggleManual = () => {
    if (this.machine.state?.matches('manual')) {
      this.machine.send('start');
    } else {
      this.machine.send('help');
    }
  };

  countDown = dropTask(async () => {
    while ((this.counter as number) > 0) {
      void this.playSound('counter');
      await timeout(1000);
      (this.counter as number)--;
    }
  });

  // GUARDS

  isGameOver = ({ context }: { context: Context }) => {
    return context.roundsToGo === 0;
  };

  // ACTIONS

  select = async () => {
    this.counter = 5;
    this.song = undefined;

    await playLobby(this.spotify.client);
    await timeout(1100);
    await this.countDown.perform();

    // eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
    const songSelected = this.song !== undefined;
    const coinToss = this.tossCoin(songSelected);
    // eslint-disable-next-line unicorn/prefer-minimal-ternary
    const playlist = coinToss === 0 ? this.dancePlaylist : this.surprisePlaylist;
    const track = this.findTrack(playlist);

    /*
      Somehow, the effect will not play:
      - when the sound is via bluetooth
      - when spotify is paused
      - then there is no effect sound

      Exact reason is unclear, but it could be a race-condition for the sound of
      being either off (spotify pause) vs on (playing the effect), which for the
      bluetooth speaker may be the spotify pause that is the winner.

      No idea tbh.

      The workaround:
      - fetch the volume from spotify
      - mute spotify
      - restore volume
    */

    await this.spotify.client.setVolume(0);
    await this.playSound(coinToss === 0 ? 'countDown' : 'surprise');

    await timeout(1000);
    await this.spotify.client.setVolume(100);
    this.machine.send('dance', { track });
  };

  dance = async ({ context, event }: { context: Context; event: GameEvent }) => {
    assertEvent(event, 'dance');

    await this.playTrackForDancing(event.track, context.duration);

    // timer
    this.counter = context.duration;

    while (this.counter > 0) {
      await timeout(1000);
      this.counter--;
    }

    // finish up this round
    this.machine.send('finish');
  };

  finish = async () => {
    await this.spotify.client.pause();
  };

  // NOTE: declared after all actions and guards it references — xstate's
  // `provide` resolves the implementation map at construction time, so class
  // fields evaluate in declaration order and a `machine` field placed above
  // them would capture `undefined`.
  machine = useMachine(this, () => ({
    machine: Machine.provide({
      /* eslint-disable @typescript-eslint/no-misused-promises -- xstate invokes actions
         without awaiting; the async bodies are fire-and-forget by design */
      actions: {
        // (defined inline so `assign` infers its generics from the provided
        // action's context/event types)
        play: assign(({ event }) => {
          assertEvent(event, 'play');

          return {
            rounds: event.rounds,
            duration: event.duration,
            roundsToGo: event.rounds - 1
          };
        }),
        select: this.select,
        dance: this.dance,
        finish: this.finish,
        finishRound: assign(({ context }) => {
          return {
            roundsToGo: context.roundsToGo - 1
          };
        })
      },
      /* eslint-enable @typescript-eslint/no-misused-promises */
      guards: {
        isGameOver: this.isGameOver
      }
    })
  }));

  // The Form's submit callback must return nothing: pahu reads a returned
  // value as the submit state (`undefined` passes, a stray object fails on
  // `state.issues.map`), so the callback body deliberately discards `send`'s
  // (non-)result — v5's `send` returns nothing.
  startGame = (params: GameParams) => {
    this.machine.send('play', params);
  };

  selectSong = async (song: number) => {
    await this.playSound('select');
    this.song = song;
  };

  tossCoin(songSelected: boolean) {
    return random(songSelected ? [0.75, 0.25] : [0.25, 0.75]);
  }

  findTrack(playlist: Playlist) {
    return getRandomTrack(getTracks(playlist));
  }

  stop = async () => {
    await this.countDown.cancelAll();
    await this.spotify.client.pause();

    this.machine.send('stop');
  };

  <template>
    <Portal @target="dance-oh-mat-header">
      <IconButton
        @icon={{IconQuestion}}
        @importance="plain"
        @spacing="-1"
        @disabled={{this.machine.state.matches "playing"}}
        @push={{this.toggleManual}}
        @label="Anleitung"
      />
    </Portal>

    {{#if (this.machine.state.matches "manual")}}
      <Manual />
    {{else if (this.machine.state.matches "lobby")}}
      <Lobby @play={{this.startGame}} />
    {{else if (this.machine.state.matches "playing")}}
      <div class="playing">

        {{! v5's typed `matches` wants partial state values, not dotted strings }}
        {{#if (this.machine.state.matches (hash playing="selection"))}}
          <p class="counter">{{this.counter}}</p>

          <div class="selection">
            {{#each (array 1 2 3 4) as |song|}}
              <Button @push={{fn this.selectSong song}}>
                {{song}}
              </Button>
            {{/each}}
          </div>
        {{else}}
          <p class="counter">{{this.counter}}</p>

          <p class="dance">
            Dance!
          </p>
        {{/if}}

        <SpotifyPlayButton
          @intent="stop"
          class="stop"
          {{on "click" this.stop}}
        >Stop</SpotifyPlayButton>
      </div>
    {{/if}}

    <style scoped>
      .playing {
        display: flex;
        flex-direction: column;
        flex-grow: 1;
        gap: var(--spacing-container0);

        /* min-height: calc(100dvh - var(--offset)); */
      }

      .selection {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(40%, 1fr));
        gap: 2rem;
        justify-content: center;

        button {
          /* touch */
          @media (hover: none) and (pointer: coarse) {
            aspect-ratio: 1;
          }
        }
      }

      .counter {
        font-size: 8rem;
        text-align: center;
      }

      .dance {
        font-size: 36px;
        font-style: italic;
        text-align: center;
        text-transform: uppercase;
        letter-spacing: 5px;
      }

      .stop {
        margin-block-start: auto;
      }
    </style>
  </template>
}

const DanceOhMat: TOC<object> = <template>
  <header class="header">
    <h1>Dance Oh! Mat</h1>
    <PortalTarget @name="dance-oh-mat-header" />
  </header>
  <WithSpotify>
    <Game />
  </WithSpotify>

  <style scoped>
    .header {
      display: flex;

      h1 {
        margin-bottom: 0;
      }

      button {
        font-size: var(--s0);
      }
    }
  </style>
</template>;

export { DanceOhMat };
