import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import {
  PlaylistChooser,
  WithSpotify,
  formatArtists,
  PlaylistResource,
  getRandomTracks,
  SpotifyService,
  isReadyForPlayback
} from '../audio/spotify';
import { AudioPlayer, AudioService } from '../audio';
import { service } from '@ember/service';
import { on } from '@ember/modifier';
import { dropTask, timeout } from 'ember-concurrency';
import preventDefault from 'ember-event-helpers/helpers/prevent-default';
import { eq, not } from 'ember-truth-helpers';
import styles from './dance-mix.css';
import { fn } from '@ember/helper';
import { htmlSafe } from '@ember/template';
import { createMachine } from 'xstate';
import { useMachine } from 'ember-statecharts';
import type Owner from '@ember/owner';
import { registerDestructor } from '@ember/destroyable';
import type RouterService from '@ember/routing/router-service';
import type { TOC } from '@ember/component/template-only';
import type { Playlist } from '../audio/spotify';

enum PlaylistOptions {
  Epic = 'epic',
  Mood = 'mood'
}

const PLAYLISTS: Record<PlaylistOptions, string> = {
  epic: '3qaxO2Z99batsuhi12MDsn',
  mood: '1IYCpukYnxGg2Yps59E9F6'
};

export enum DanceMixParam {
  Amount = 'amount',
  Duration = 'duration',
  Pause = 'pause',
  Playlist = 'playlist',
  PlaylistId = 'playlistId'
}

export interface DanceMixParams {
  [DanceMixParam.Amount]?: number;
  [DanceMixParam.Duration]?: number;
  [DanceMixParam.Pause]?: number;
  [DanceMixParam.Playlist]?: PlaylistOptions;
  [DanceMixParam.PlaylistId]?: string;
}

type GameParams = Required<
  Pick<DanceMixParams, DanceMixParam.Amount | DanceMixParam.Duration | DanceMixParam.Pause>
>;

const DEFAULTS = {
  [DanceMixParam.Amount]: 5,
  [DanceMixParam.Duration]: 30,
  [DanceMixParam.Pause]: 1,
  [DanceMixParam.Playlist]: undefined,
  [DanceMixParam.PlaylistId]: undefined
};

const getParam =
  <A extends DanceMixParams>(args: A, router: RouterService) =>
  <P extends DanceMixParam>(param: P): A[P] => {
    if (args[param]) {
      return args[param];
    }

    if (router.currentRoute?.queryParams[param]) {
      return router.currentRoute.queryParams[param] as A[P];
    }

    return DEFAULTS[param] as A[P];
  };

const DanceMixMachine = createMachine({
  id: 'Dance Mix',
  initial: 'preparing',
  // entry: ['selectPlayer', 'readSettings'],
  states: {
    preparing: {
      on: {
        play: {
          target: 'playing'
        },
        choosePlaylist: {
          target: 'choosing-playlist'
        }
      }
    },
    playing: {
      exit: 'stop',
      on: {
        stop: {
          target: 'preparing'
        }
      }
    },
    'choosing-playlist': {
      on: {
        selectPlaylist: {
          target: 'preparing'
        }
      }
    }
  }
});

const Header: TOC<{ Args: { playlist?: Playlist }; Blocks: { default: [] } }> = <template>
  <div class='grid'>
    <p>
      {{#if @playlist}}
        <strong>{{htmlSafe @playlist.name}}</strong><br />
        <small>{{htmlSafe (if @playlist.description @playlist.description '')}}</small>
      {{/if}}
    </p>

    {{yield}}
  </div>
</template>;

interface PlaySignature {
  Args: GameParams & {
    playlist: PlaylistResource;
    finish: () => void;
  };
}

class Play extends Component<PlaySignature> {
  @service declare spotify: SpotifyService;

  @tracked counter?: number;
  @tracked declare tracks: SpotifyApi.TrackObjectFull[];

  constructor(owner: Owner, args: PlaySignature['Args']) {
    super(owner, args);

    this.start();
  }

  start = async () => {
    if (this.args.playlist.tracks) {
      this.tracks = getRandomTracks(this.args.playlist.tracks, this.args.amount);

      await this.mix.perform({
        duration: this.args.duration,
        pause: this.args.pause,
        tracks: this.tracks
      });

      this.finish();
    }
  };

  mix = dropTask(
    async ({
      tracks,
      duration,
      pause
    }: {
      duration: number;
      pause: number;
      tracks: SpotifyApi.TrackObjectFull[];
    }) => {
      for (const track of tracks) {
        await this.playTrack.perform(track, duration);
        this.spotify.client.pause();
        await timeout(pause * 1000);
      }
    }
  );

  playTrack = dropTask(async (track: SpotifyApi.TrackObjectFull, duration: number) => {
    const start = Math.round(track.duration_ms * 0.33);
    await this.spotify.client.play({
      uris: [track.uri],
      position_ms: start
    });

    this.spotify.client.selectTrack(track);

    this.counter = duration;

    while (this.counter > 0) {
      await timeout(1000);
      this.counter--;
    }
  });

  stop = async () => {
    await this.playTrack.cancelAll();
    await this.mix.cancelAll();

    this.finish();
  };

  finish = async () => {
    if (this.spotify.client.playing) {
      await this.spotify.client.pause();
    }

    this.args.finish();
  }

  <template>
    <div class='grid'>
      <ol class={{styles.tracks}}>
        {{#each this.tracks as |track|}}
          <li aria-selected={{eq track this.spotify.client.track.data}}>
            {{track.name}}<br />
            <small>{{formatArtists track.artists}}</small>
          </li>
        {{/each}}
      </ol>

      <div>
        <p class={{styles.counter}}>{{this.counter}}</p>

        <button type='button' {{on 'click' this.stop}}>Stop</button>
      </div>
    </div>
  </template>
}

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
      duration: this.getParam(DanceMixParam.Duration),
      pause: this.getParam(DanceMixParam.Pause),
      amount: this.getParam(DanceMixParam.Amount)
    };
  }

  start = (event: SubmitEvent) => {
    const data = new FormData(event.target as HTMLFormElement);

    const params: GameParams = {
      duration: Number.parseInt(data.get('duration') as string, 10),
      pause: Number.parseInt(data.get('pause') as string, 10),
      amount: Number.parseInt(data.get('amount') as string, 10)
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
        Pause zwischen den Liedern [sec]:
        <input type='number' name='pause' value={{this.params.pause}} />
      </label>

      <label>
        Lieder [Anzahl]:
        <input type='number' name='amount' value={{this.params.amount}} />
      </label>

      {{#if (isReadyForPlayback)}}
        <button type='submit'>Start</button>
      {{else}}
        Bitte Spotify Player auswählen
      {{/if}}
    </form>
  </template>
}

export interface DanceMixSignature {
  Args: DanceMixParams;
}

class Game extends Component<DanceMixSignature> {
  @service('player') declare audio: AudioService;
  @service declare router: RouterService;

  get getParam() {
    return getParam(this.args, this.router);
  }

  //
  // Boot
  //
  constructor(owner: Owner, args: DanceMixSignature['Args']) {
    super(owner, args);

    this.readSettings();

    this.audio.player = AudioPlayer.Spotify;

    registerDestructor(this, () => {
      this.audio.player = undefined;
    });
  }

  readSettings = () => {
    this.selectedPlaylistId = localStorage.getItem('dance-playlist') as string;
  };

  machine = useMachine(this, () => ({
      machine: DanceMixMachine
    })
  );

  //
  // Manage Playlist
  //

  @tracked selectedPlaylistId?: string;

  get playlistId(): string | undefined {
    if (this.selectedPlaylistId) {
      return this.selectedPlaylistId;
    }

    const playlistId = this.getParam(DanceMixParam.PlaylistId) as string;
    if (playlistId) {
      return playlistId;
    }

    const playlist = this.getParam(DanceMixParam.Playlist) as PlaylistOptions;
    if (playlist && PLAYLISTS[playlist]) {
      return PLAYLISTS[playlist];
    }

    const savedPlaylist = localStorage.getItem('dance-playlist') as string;
    if (savedPlaylist) {
      return savedPlaylist;
    }

    // fallback to epic playlist
    return PLAYLISTS[PlaylistOptions.Epic];
  }

  playlist = PlaylistResource.from(this, () => ({ playlist: this.playlistId }));

  selectPlaylist = (playlist: SpotifyApi.PlaylistObjectSimplified) => {
    const id = playlist.id;
    localStorage.setItem('dance-playlist', id);

    this.selectedPlaylistId = id;
    this.machine.send('selectPlaylist');
  };

  get playlistLocked() {
    return (
      this.getParam(DanceMixParam.Playlist) !== undefined ||
      this.getParam(DanceMixParam.PlaylistId) !== undefined
    );
  }

  //
  // Game Loop
  //

  @tracked declare params: GameParams;

  play = (params: GameParams) => {
    this.params = params;
    this.machine.send('play');
  };

  finish = () => {
    this.machine.send('stop');
  };

  <template>
    {{#if (this.machine.state.matches 'choosing-playlist')}}
      <PlaylistChooser @select={{this.selectPlaylist}} />
    {{else if (this.machine.state.matches 'preparing')}}
      <Header @playlist={{this.playlist.playlist}}>
        {{#if (not this.playlistLocked)}}
          <div>
            <button
              type='button'
              disabled={{(this.machine.state.matches 'playing')}}
              class='outline'
              {{on 'click' (fn this.machine.send 'choosePlaylist')}}
            >
              Playlist wechseln
            </button>
          </div>
        {{/if}}
      </Header>
      <Lobby @duration={{@duration}} @pause={{@pause}} @amount={{@amount}} @play={{this.play}} />
    {{else if (this.machine.state.matches 'playing')}}
      <Header @playlist={{this.playlist.playlist}} />
      <Play
        @playlist={{this.playlist}}
        @duration={{this.params.duration}}
        @pause={{this.params.pause}}
        @amount={{this.params.amount}}
        @finish={{this.finish}}
      />
    {{/if}}
  </template>
}

export default class DanceMix extends Component<DanceMixSignature> {
  <template>
    <h1>Dance Mix</h1>

    <WithSpotify>
      <Game
        @amount={{@amount}}
        @duration={{@duration}}
        @pause={{@pause}}
        @playlist={{@playlist}}
        @playlistId={{@playlistId}}
      />
    </WithSpotify>
  </template>
}
