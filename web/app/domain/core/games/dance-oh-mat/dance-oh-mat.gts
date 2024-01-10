import Component from '@glimmer/component';
import { service } from '@ember/service';
import { tracked } from '@glimmer/tracking';
import { AudioPlayer, AudioService, playSound } from '@unidancing/audio';
import {
  WithSpotify,
  SpotifyService,
  TrackResource,
  SpotifyClient,
  isReadyForPlayback,
  PlaylistResource,
  getRandomTrack,
  playTrack,
  playTrackForDancing
} from '@unidancing/spotify';
import { on } from '@ember/modifier';
import { dropTask, timeout } from 'ember-concurrency';
import type { Track, Device } from '@unidancing/spotify';
import type { TOC } from '@ember/component/template-only';
import preventDefault from 'ember-event-helpers/helpers/prevent-default';
import { createMachine, assign } from 'xstate';
import { useMachine } from 'ember-statecharts';
import { Icon } from '@unidancing/ui';
import { registerDestructor } from '@ember/destroyable';
import styles from './dance-oh-mat.css';
import type Owner from '@ember/owner';
import type RouterService from '@ember/routing/router-service';
import { fn, array } from '@ember/helper';
import { getOwner } from '@ember/owner';

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
    if (args[param]) {
      return args[param];
    }

    if (router.currentRoute?.queryParams[param]) {
      return router.currentRoute.queryParams[param] as A[P];
    }

    return DEFAULTS[param] as A[P];
  };

type Context = { rounds: number; duration: number; roundsToGo: number };
const Machine = createMachine(
  {
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
                  cond: 'isGameOver',
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
    },
    schema: {
      events: {} as
        | { type: 'help' }
        | ({ type: 'play' } & GameParams)
        | { type: 'dance'; track: {} }
        | { type: 'start' }
        | { type: 'finish' }
        | { type: 'stop' },
      context: {} as Context
    },
    predictableActionArguments: true,
    preserveActionOrder: true
  },
  {
    actions: {
      select: (_context, _event) => {},
      dance: (_context, _event) => {},
      play: (_context, _event) => {},
      finish: (_context, _event) => {},
      finishRound: (_context, _event) => {}
    },
    services: {},
    guards: {
      isGameOver: (_context, _event) => {
        return false;
      }
    },
    delays: {}
  }
);

const LOBBY_TRACK_ID = '7IiurNiwebWtRFrMUojN04';

const playLobby = async (track: Track, client: SpotifyClient) => {
  await client.play({
    uris: [track.uri]
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

  start = (event: SubmitEvent) => {
    const data = new FormData(event.target as HTMLFormElement);

    const params: GameParams = {
      duration: Number.parseInt(data.get('duration') as string, 10),
      rounds: Number.parseInt(data.get('rounds') as string, 10)
    };

    this.args.play(params);
  };

  <template>
    <form {{on 'submit' (preventDefault this.start)}}>
      <label>
        Dauer pro Lied [sec]:
        <input type='number' name='duration' value={{this.params.duration}} />
      </label>

      <label>
        Runden [Anzahl]:
        <input type='number' name='rounds' value={{this.params.rounds}} />
      </label>

      {{#if (isReadyForPlayback)}}
        <button type='submit'>Start</button>
      {{else}}
        Bitte Spotify Player auswählen
      {{/if}}
    </form>
  </template>
}

class Manual extends Component {
  @service declare spotify: SpotifyService;
  @service('player') declare audio: AudioService;

  lobbyTrack = TrackResource.from(this, () => ({ id: LOBBY_TRACK_ID }));

  playLobby = async () => {
    await playLobby(this.lobbyTrack.data as Track, this.spotify.client);
  };

  togglePlay = async () => {
    if (this.spotify.client.playing) {
      this.spotify.client.pause();
    } else {
      await this.playLobby();
    }
  };

  <template>
    <h1>Anleitung</h1>

    <ol class={{styles.manual}}>
      <li>Es werden vier Runden gespielt, jede Runde wird zu einem Song getanzt.</li>
      <li>Die Runde beginnt:
        <ul>
          <li>
            Musik zur Song Auswahl:
            <button type='button' {{on 'click' this.togglePlay}}>
              {{#if this.spotify.client.playing}}
                <Icon @icon='pause' />
              {{else}}
                <Icon @icon='play' />
              {{/if}}
            </button>
          </li>
          <li>Die Auswahl dauert 5 Sekunden, der Countdown start</li>
          <li>
            Auswahl aus 4 Songs:<br>
            3x Chance auf "Tanzbaren Song"<br>
            1x Chance auf "Überraschung"
          </li>
        </ul>
      </li>

      <li>
        Songauswahl eingeben

        <button type='button' {{on 'click' (fn (playSound) 'select')}}>
          Eingabe
        </button>
      </li>
      <li>
        Ohne Songauswahl: <br>75% Chance auf Überraschung
      </li>
      <li>
        Die Runde startet mit<br>

        <button type='button' {{on 'click' (fn (playSound) 'countDown')}}>
          Tanzbarer Song
        </button>

        <button type='button' {{on 'click' (fn (playSound) 'surprise')}}>
          Überraschung
        </button>
      </li>
      <li><i>Dance!</i></li>
    </ol>
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
  @service declare spotify: SpotifyService;
  @service('player') declare audio: AudioService;

  @tracked counter?: number;
  song?: number;

  dancePlaylist = PlaylistResource.from(this, () => ({ playlist: PLAYLISTS['epic'] }));
  surprisePlaylist = PlaylistResource.from(this, () => ({ playlist: PLAYLISTS['surprise'] }));

  //
  // Boot
  //
  constructor(owner: Owner, args: {}) {
    super(owner, args);

    this.audio.player = AudioPlayer.Spotify;

    // load resources
    this.lobbyTrack.load(LOBBY_TRACK_ID);
    this.dancePlaylist.load();
    this.surprisePlaylist.load();

    registerDestructor(this, () => {
      this.audio.player = undefined;
    });
  }

  machine = useMachine(this, () => {
    const { play, select, dance, finish, finishRound, isGameOver } = this;

    return {
      machine: Machine.withConfig({
        actions: { play, select, dance, finish, finishRound },
        guards: { isGameOver }
      })
    };
  });

  lobbyTrack = TrackResource.from(this, () => []);

  // playLobby = async () => {
  //   await playLobby(this.lobbyTrack.data as Track, this.spotify.client);
  // };

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
      this.playSound('counter');
      await timeout(1000);
      (this.counter as number)--;
    }
  });

  // GUARDS

  isGameOver = (context: Context) => {
    return context.roundsToGo === 0;
  };

  // ACTIONS

  play = assign((_context: Context, params: { type: 'play' } & GameParams) => {
    return {
      rounds: params.rounds,
      duration: params.duration,
      roundsToGo: params.rounds - 1
    };
  });

  select = async () => {
    this.counter = 5;
    this.song = undefined;

    const devicesPromise = this.spotify.client.api.getMyDevices();
    await this.playTrack(this.lobbyTrack.data as Track);
    await timeout(1100);
    await this.countDown.perform();

    const songSelected = this.song !== undefined;
    const coinToss = this.tossCoin(songSelected);
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

    const devicesResponse = await devicesPromise;
    const volume = (devicesResponse.devices.find(device => device.is_active) as Device).volume_percent as number;

    await this.spotify.client.setVolume(0);
    await this.playSound(coinToss === 0 ? 'countDown' : 'surprise');

    await timeout(1000);
    await this.spotify.client.setVolume(volume);
    this.machine.send('dance', { track });
  };

  dance = async (context: Context, { track }: { track: Track; type: 'dance' }) => {
    await this.playTrackForDancing(track, context.duration);
    this.spotify.client.selectTrack(track);

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

  finishRound = assign((context: Context) => {
    return {
      ...context,
      roundsToGo: context.roundsToGo - 1
    };
  });

  selectSong = async (song: number) => {
    await this.playSound('select');
    this.song = song;
  };

  tossCoin(songSelected: boolean) {
    return random(songSelected ? [0.75, 0.25] : [0.25, 0.75]);
  }

  findTrack(playlist: PlaylistResource) {
    return getRandomTrack(playlist.tracks as Track[]);
  }

  stop = async () => {
    await this.countDown.cancelAll();
    await this.spotify.client.pause();

    this.machine.send('stop');
  };

  <template>
    <button
      type='button'
      class='outline {{styles.info}}'
      disabled={{this.machine.state.matches 'playing'}}
      {{on 'click' this.toggleManual}}
    >
      <Icon @icon='info' />
    </button>

    {{#if (this.machine.state.matches 'manual')}}
      <Manual />
    {{else if (this.machine.state.matches 'lobby')}}
      <Lobby @play={{fn this.machine.send 'play'}} />
    {{else if (this.machine.state.matches 'playing')}}
      <div class={{styles.playing}}>

        {{#if (this.machine.state.matches 'playing.selection')}}
          <p class={{styles.counter}}>{{this.counter}}</p>

          <div class={{styles.selection}}>
            {{#each (array 1 2 3 4) as |song|}}
              <button type='button' {{on 'click' (fn this.selectSong song)}}>
                {{song}}
              </button>
            {{/each}}
          </div>
        {{else}}
          <p class={{styles.counter}}>{{this.counter}}</p>

          <p class={{styles.dance}}>
            Dance!
          </p>
        {{/if}}

        <button type="button" class={{styles.stop}} {{on "click" this.stop}}>Stop</button>
      </div>
    {{/if}}
  </template>
}

const DanceOhMat: TOC<{}> = <template>
  <header class={{styles.header}}><h1>Dance Oh! Mat</h1></header>
  <WithSpotify>
    <Game />
  </WithSpotify>
</template>;

export { DanceOhMat };
