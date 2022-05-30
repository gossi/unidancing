import { action } from '@ember/object';
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import {
  PlaylistResource,
  getRandomTracks
} from '../resources/spotify/playlist';
import didInsert from 'ember-render-helpers/helpers/did-insert';
import PlaylistChooser from './playlist-chooser';
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
import styles from './dance-mix.css';
import set from 'ember-set-helper/helpers/set';
import { fn } from '@ember/helper';
import { htmlSafe } from '@ember/template';

export default class DanceMixComponent extends Component {
  @service declare spotify: Services['spotify'];
  @service('player') declare playerService: Services['player'];

  player!: SpotifyPlayer;

  @tracked playlistId?: string;
  @tracked counter?: number;

  resource: PlaylistResource = PlaylistResource.from(this, () => ({
    playlist: this.playlistId
  }));

  @tracked tracks?: SpotifyApi.TrackObjectFull[];
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
  readSettings() {
    this.playlistId = localStorage.getItem('dance-playlist') as string;
  }

  @action
  selectPlaylist(playlist: SpotifyApi.PlaylistObjectSimplified) {
    const id = playlist.id;
    localStorage.setItem('dance-playlist', id);

    this.playlistId = id;
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
    {{didInsert this.selectPlayer}}
    {{didInsert this.readSettings}}

    {{#if this.playlistId}}
      <div class="grid">
        <p>
          <strong>{{htmlSafe this.resource.playlist.name}}</strong><br>
          <small>{{htmlSafe this.resource.playlist.description}}</small>
        </p>

        <div>
          <button
            type="button"
            disabled={{this.mix.isRunning}}
            class="outline"
            {{on "click" (fn (set this "playlistId" undefined))}}
          >
            Playlist wechseln
          </button>
        </div>
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
            <input type="number" name="duration" value="30">
          </label>

          <label>
            Pause zwischen den Liedern [sec]:
            <input type="number" name="pause" value="1">
          </label>

          <label>
            Lieder [Anzahl]:
            <input type="number" name="amount" value="5">
          </label>

          <button type="submit">Start</button>
        </form>
      {{/if}}

    {{else}}
      <PlaylistChooser @select={{this.selectPlaylist}} />
    {{/if}}
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    DanceMix: typeof DanceMixComponent;
  }
}
