import { action } from '@ember/object';
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import {
  PlaylistResource,
  getRandomTracks
} from '../resources/spotify/playlist';
import didInsert from 'ember-render-helpers/helpers/did-insert';
import willDestroy from 'ember-render-helpers/helpers/will-destroy';
import PlaylistChooser from '../components/playlist-chooser';
import LoginWithSpotify from '../components/login-with-spotify';
import { service, Registry as Services } from '@ember/service';
import { on } from '@ember/modifier';
import {useTrack} from '../resources/spotify/track';
import {formatArtists} from '../utils/spotify';
import SpotifyPlayer from '../player/spotify';
import {lookupPlayer} from '../player/player';
import { getOwner } from '@ember/application';
import { dropTask, timeout } from 'ember-concurrency';
import { taskFor } from 'ember-concurrency-ts';
import preventDefault from 'ember-event-helpers/helpers/prevent-default';
import eq from 'ember-truth-helpers/helpers/equal';
import not from 'ember-truth-helpers/helpers/not';
import styles from './dance-mix.css';
import set from 'ember-set-helper/helpers/set';
import { fn } from '@ember/helper';
import { htmlSafe } from '@ember/template';

enum Playlist {
  Epic = 'epic',
  Mood = 'mood'
}

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
  [DanceMixParam.Playlist]?: Playlist;
  [DanceMixParam.PlaylistId]?: string;
};

const PLAYLISTS: Record<Playlist, string> = {
  epic: '3qaxO2Z99batsuhi12MDsn',
  mood: '1IYCpukYnxGg2Yps59E9F6'
};

const DEFAULTS = {
  [DanceMixParam.Amount]: 5,
  [DanceMixParam.Duration]: 30,
  [DanceMixParam.Pause]: 1,
  [DanceMixParam.Playlist]: undefined,
  [DanceMixParam.PlaylistId]: undefined
}

export interface DanceMixSignature {
  Args: DanceMixParams
}

export default class DanceMixComponent extends Component<DanceMixSignature> {
  @service declare spotify: Services['spotify'];
  @service declare router: Services['router'];
  @service('player') declare playerService: Services['player'];

  player!: SpotifyPlayer;

  @tracked selectedPlaylistId?: string;
  @tracked counter?: number;

  get playlistId(): string | undefined {
    if (this.selectedPlaylistId) {
      return this.selectedPlaylistId;
    }

    const playlistId = this.#getParam(DanceMixParam.PlaylistId) as string;
    if (playlistId) {
      return playlistId;
    }

    const playlist = this.#getParam(DanceMixParam.Playlist) as Playlist;
    if (playlist && PLAYLISTS[playlist]) {
      return PLAYLISTS[playlist];
    }

    const savedPlaylist = localStorage.getItem('dance-playlist') as string
    if (savedPlaylist) {
      return savedPlaylist;
    }

    return undefined;
  }

  resource: PlaylistResource = PlaylistResource.from(this, () => ({
    playlist: this.playlistId
  }));

  @tracked tracks?: SpotifyApi.TrackObjectFull[];

  @tracked state?: 'choose-playlist';

  get choosingPlaylist() {
    return !this.playlistId || this.state === 'choose-playlist';
  }

  get playlistLocked() {
    return this.#getParam(DanceMixParam.Playlist) !== undefined ||
      this.#getParam(DanceMixParam.PlaylistId) !== undefined;
  }

  // params
  #getParam(param: DanceMixParam) {
    if (this.args[param]) {
      return this.args[param];
    }

    if (this.router.currentRoute.queryParams[param]) {
      return this.router.currentRoute.queryParams[param];
    }

    return DEFAULTS[param];
  }

  get amount() {
    return this.#getParam(DanceMixParam.Amount);
  }

  get duration() {
    return this.#getParam(DanceMixParam.Duration);
  }

  get pause() {
    return this.#getParam(DanceMixParam.Pause);
  }


  // @action
  // loadAnalytics() {
  //   const resources = this.tracks
  //     .map(track => TrackResource.from(this, () => ({
  //       track
  //     })))
  //     .forEach(async res => await res.loadAnalysis());
  // }

  @action
  selectPlayer() {
    this.player = lookupPlayer(SpotifyPlayer, getOwner(this));
    this.playerService.player = this.player;
  }

  @action
  unloadPlayer() {
    this.playerService.player = undefined;
  }

  @action
  readSettings() {
    // this.selectedPlaylistId = localStorage.getItem('dance-playlist') as string;
  }

  @action
  selectPlaylist(playlist: SpotifyApi.PlaylistObjectSimplified) {
    const id = playlist.id;
    localStorage.setItem('dance-playlist', id);

    this.selectedPlaylistId = id;
    this.state = undefined;
  }

  @action
  selectTrack(track: SpotifyApi.TrackObjectFull) {
    this.player.track = useTrack(this, { track });
  }

  @action
  start(event: SubmitEvent) {
    const data = new FormData(event.target as HTMLFormElement);
    const amount = Number.parseInt(data.get('amount') as string, 10);

    if (this.resource.tracks) {
      const tracks = getRandomTracks(this.resource.tracks, amount);

      taskFor(this.mix).perform({
        duration: Number.parseInt(data.get('duration') as string, 10),
        pause: Number.parseInt(data.get('pause') as string, 10),
        tracks
      });

      this.tracks = tracks;
    }
  }

  @dropTask *mix({tracks, duration, pause}: {
    duration: number;
    pause: number;
    tracks: SpotifyApi.TrackObjectFull[];
  }) {
    for (const track of tracks) {
      yield taskFor(this.playTrack).perform(track, duration);
      this.player.pause();
      yield timeout(pause * 1000);
    }
  }

  @dropTask *playTrack(track: SpotifyApi.TrackObjectFull, duration: number) {
    const start = Math.round(track.duration_ms * 0.33);
    yield this.player.play({
      uris: [track.uri],
      position_ms: start
    });
    this.selectTrack(track);

    this.counter = duration;

    while (this.counter > 0) {
      yield timeout(1000);
      this.counter--;
    }
  }

  @action
  stop() {
    taskFor(this.playTrack).cancelAll();
    taskFor(this.mix).cancelAll();
    this.player.pause();
  }

  <template>
    <h1>Dance Mix</h1>
    {{#if this.spotify.authed}}
      {{didInsert this.selectPlayer}}
      {{didInsert this.readSettings}}
      {{willDestroy this.unloadPlayer}}

      {{#if this.choosingPlaylist}}
        <PlaylistChooser @select={{this.selectPlaylist}} />
      {{else if this.playlistId}}
        <div class="grid">
          <p>
            <strong>{{htmlSafe this.resource.playlist.name}}</strong><br>
            <small>{{htmlSafe this.resource.playlist.description}}</small>
          </p>

          {{#if (not this.playlistLocked)}}
            <div>
              <button
                type="button"
                disabled={{this.mix.isRunning}}
                class="outline"
                {{on "click" (fn (set this "state" 'choose-playlist'))}}
              >
                Playlist wechseln
              </button>
            </div>
          {{/if}}
        </div>

        {{#if this.mix.isRunning}}
          <div class="grid">
            <ol class={{styles.tracks}}>
              {{#each this.tracks as |track|}}
                <li aria-selected={{eq track this.player.track.data}}>
                  {{track.name}}<br>
                  <small>{{formatArtists track.artists}}</small>
                </li>
              {{/each}}
            </ol>

            <div>
              <p class={{styles.counter}}>{{this.counter}}</p>

              <button type="button" {{on "click" this.stop}}>Stop</button>
            </div>
          </div>
        {{else}}
          <form {{on "submit" (preventDefault this.start)}}>
            <label>
              Dauer pro Lied [sec]:
              <input type="number" name="duration" value={{this.duration}}>
            </label>

            <label>
              Pause zwischen den Liedern [sec]:
              <input type="number" name="pause" value={{this.pause}}>
            </label>

            <label>
              Lieder [Anzahl]:
              <input type="number" name="amount" value={{this.amount}}>
            </label>

            <button type="submit">Start</button>
          </form>
        {{/if}}
      {{/if}}
    {{else}}
      <LoginWithSpotify />
    {{/if}}
  </template>
}
