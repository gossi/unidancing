import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { registerDestructor } from '@ember/destroyable';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';
import { getOwner } from '@ember/owner';
import { service } from '@ember/service';
import { htmlSafe } from '@ember/template';

import { didCancel, dropTask, timeout } from 'ember-concurrency';
import { service as polarisService } from 'ember-polaris-service';
import { useMachine } from 'ember-statecharts';
import { eq, not } from 'ember-truth-helpers';
import { createMachine } from 'xstate';

import { Button, Form } from '@hokulea/ember';

import { AudioPlayer, AudioService } from '../../../supporting/audio';
import {
  formatArtists,
  getRandomTracks,
  MaybeSpotifyPlayerWarning,
  PlaylistChooser,
  PlaylistResource,
  playTrackForDancing,
  SpotifyPlayButton,
  SpotifyService,
  WithSpotify
} from '../../../supporting/spotify';
import styles from './dance-mix.css';

import type { Playlist, Track } from '../../../supporting/spotify';
import type { TOC } from '@ember/component/template-only';
import type Owner from '@ember/owner';
import type RouterService from '@ember/routing/router-service';

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
    // eslint-disable-next-line @typescript-eslint/naming-convention
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
  <div class={{styles.header}}>
    <p>
      {{#if @playlist}}
        <strong>{{htmlSafe @playlist.name}}</strong><br />
        <small>{{htmlSafe (if @playlist.description @playlist.description "")}}</small>
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
  @polarisService(SpotifyService) declare spotify: SpotifyService;

  @tracked counter?: number;
  @tracked declare tracks: Track[];

  playTrackForDancing = playTrackForDancing(getOwner(this) as Owner);

  constructor(owner: Owner, args: PlaySignature['Args']) {
    super(owner, args);

    this.start();
  }

  start = async () => {
    if (this.args.playlist.tracks) {
      this.tracks = getRandomTracks(this.args.playlist.tracks, this.args.amount);

      try {
        await this.mix.perform({
          duration: this.args.duration,
          pause: this.args.pause,
          tracks: this.tracks
        });
      } catch (e) {
        if (!didCancel(e)) {
          throw e;
        }
      }

      this.finish();
    }
  };

  mix = dropTask(
    async ({ tracks, duration, pause }: { duration: number; pause: number; tracks: Track[] }) => {
      for (const track of tracks) {
        // start track
        await this.playTrackForDancing(track, duration);
        this.spotify.client.selectTrack(track);

        // start countdown
        this.counter = duration;

        while (this.counter > 0) {
          await timeout(1000);
          this.counter--;
        }

        // pause
        this.spotify.client.pause();
        await timeout(pause * 1000);
      }
    }
  );

  // playTrack = dropTask(async (track: SpotifyApi.TrackObjectFull, duration: number) => {
  //   const start = Math.round(track.duration_ms * 0.33);
  //   await this.spotify.client.play({
  //     uris: [track.uri],
  //     position_ms: start
  //   });

  //   this.spotify.client.selectTrack(track);

  //   this.counter = duration;

  //   while (this.counter > 0) {
  //     await timeout(1000);
  //     this.counter--;
  //   }
  // });

  stop = async () => {
    // await this.playTrack.cancelAll();
    await this.mix.cancelAll();

    this.finish();
  };

  finish = async () => {
    if (this.spotify.client.playing) {
      await this.spotify.client.pause();
    }

    this.args.finish();
  };

  <template>
    <SpotifyPlayButton @intent="stop" {{on "click" this.stop}}>Stop</SpotifyPlayButton>
    <div class={{styles.play}}>
      <ol class={{styles.tracks}}>
        {{#each this.tracks as |track|}}
          <li>
            {{track.name}}<br />
            <small>{{formatArtists track.artists}}</small>
          </li>
        {{/each}}
      </ol>

      <div>
        <p class={{styles.counter}}>{{this.counter}}</p>
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

  start = (data: GameParams) => {
    this.args.play(data);
  };

  <template>
    <Form @data={{this.params}} @submit={{this.start}} as |f|>
      <f.Number @name="duration" @label="Dauer pro Lied [sec]" />
      <f.Number @name="pause" @label="Pause zwischen den Liedern [sec]" />
      <f.Number @name="amount" @label="Lieder [Anzahl]" />

      <MaybeSpotifyPlayerWarning />

      <SpotifyPlayButton type="submit">Start</SpotifyPlayButton>
    </Form>
  </template>
}

export interface DanceMixSignature {
  Args: DanceMixParams;
}

class Game extends Component<DanceMixSignature> {
  @polarisService(AudioService) declare audio: AudioService;
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
  }));

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

  selectPlaylist = (playlist: Playlist) => {
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
    {{#if (this.machine.state.matches "choosing-playlist")}}
      <PlaylistChooser @select={{this.selectPlaylist}} />
    {{else if (this.machine.state.matches "preparing")}}
      <Header @playlist={{this.playlist.playlist}}>
        {{#unless this.playlistLocked}}

          <Button
            @importance="subtle"
            @disabled={{this.machine.state.matches "playing"}}
            @push={{fn this.machine.send "choosePlaylist"}}
          >
            Playlist wechseln
          </Button>

        {{/unless}}
      </Header>
      <Lobby @duration={{@duration}} @pause={{@pause}} @amount={{@amount}} @play={{this.play}} />
    {{else if (this.machine.state.matches "playing")}}
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

export const DanceMix: TOC<DanceMixSignature> = <template>
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
</template>;
