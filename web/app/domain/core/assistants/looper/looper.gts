import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { dropTask, timeout } from 'ember-concurrency';
import { service } from '@ember/service';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import styles from './looper.css';
import { registerDestructor } from '@ember/destroyable';
import { eq } from 'ember-truth-helpers';

import { AudioPlayer, AudioService } from '../../../supporting/audio';
import {
  WithSpotify,
  SpotifyService,
  TrackResource,
  formatArtists
} from '../../../supporting/spotify';
import type { Track } from '../../../supporting/spotify';
import type { TOC } from '@ember/component/template-only';

interface Loop {
  track?: Track;
  start: number;
  end: number;
  trackId: string;
}

const data: Loop[] = [
  {
    start: 27787,
    end: 82648,
    trackId: '69yfbpvmkIaB10msnKT7Q5'
  }
];

class Game extends Component {
  @service declare spotify: SpotifyService;
  @service('player') declare audio: AudioService;

  @tracked latency = 250;
  @tracked loops: Required<Loop>[] = [];
  @tracked playing?: Loop;

  constructor(owner: unknown, args: {}) {
    super(owner, args);

    this.audio.player = AudioPlayer.Spotify;

    registerDestructor(this, () => {
      this.audio.player = undefined;
    });

    this.load();
  }

  async load() {
    this.loops = await Promise.all(data.map(async (loop) => {
      const resource = TrackResource.from(this, () => ({ id : loop.trackId }));
      await resource.load(loop.trackId);

      return {
        ...loop,
        track: resource.data as Track,
      }
    }));
  }

  start = async (loop: Required<Loop>) => {
    this.playing = loop;

    try {
      await this.play.perform(loop);
    } catch(_) {}
  }

  play = dropTask(async (loop: Required<Loop>) => {
    this.spotify.client.selectTrack(loop.track);

    while (true) {
      await this.spotify.client.play({
        uris: [loop.track.uri],
        position_ms: loop.start
      });

      await timeout((loop.end - loop.start) - this.latency);
    }
  });

  stop = async () => {
    await this.play.cancelAll();
    await this.spotify.client.pause();
    this.playing = undefined;
  };

  updateLatency = (event: Event) => {
    this.latency = Number.parseFloat((event.target as HTMLInputElement).value);
  }

  <template>
    <label>
      Latenz [ms]
      <input type="text" value={{this.latency}} {{on "change" this.updateLatency}}>
    </label>


      {{#each this.loops as |item|}}
        <article class={{styles.loop}}>
          <span>
            <strong>{{item.track.name}}</strong><br>
            {{formatArtists item.track.artists}}
          </span>

          {{#if (eq item this.playing)}}
            <button type="button" {{on "click" this.stop}}>Stop</button>
          {{else}}
            <button type="button" {{on "click" (fn this.start item)}}>Start</button>
          {{/if}}
        </article>
      {{/each}}

  </template>
}

const Looper: TOC<{}> = <template>
  <h1>Loops</h1>

  <WithSpotify>
    <Game/>
  </WithSpotify>
</template>


export { Looper };
