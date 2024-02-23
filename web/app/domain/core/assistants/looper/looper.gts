import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { dropTask, timeout } from 'ember-concurrency';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import styles from './looper.css';
import { registerDestructor } from '@ember/destroyable';
import { eq } from 'ember-truth-helpers';
import { service } from 'ember-polaris-service';
import set from 'ember-set-helper/helpers/set';
import pick from 'ember-composable-helpers/helpers/pick';

import { AudioPlayer, AudioService } from '../../../supporting/audio';
import {
  WithSpotify,
  SpotifyService,
  TrackResource,
  formatArtists
} from '../../../supporting/spotify';
import type { Track } from '../../../supporting/spotify';
import type { TOC } from '@ember/component/template-only';

interface LoopDescriptor {
  start: number;
  end: number;
  description?: string;
  trackId: string;
  dev?: boolean;
}

interface Loop extends LoopDescriptor{
  track: Track;
  duration: number;
}

const data: LoopDescriptor[] = [
  // Radioactive by Imagine Dragons
  {
    trackId: '69yfbpvmkIaB10msnKT7Q5',
    start: 27787,
    end: 82648,
    description: 'verse + chorus'
  },
  // Vikings - Axe and Sword
  // https://open.spotify.com/intl-de/track/4SnaUdWZrAIfmvwdclYWhn?si=6f7c26d5c8ed47fc
  // {
  //   start: 82000,
  //   end: 115000,
  //   trackId: '4SnaUdWZrAIfmvwdclYWhn'
  // }

  // The Call
  // https://open.spotify.com/intl-de/track/2iI556oF2qwtac9r1RzrXo?si=4d2349d38e8f48f7
  {
    trackId: '2iI556oF2qwtac9r1RzrXo',
    start: 70000,
    end: 130700,
    description: 'half first chorus (4/4) + bridge (6/8)'
  },
  {
    trackId: '2iI556oF2qwtac9r1RzrXo',
    start: 90100,
    end: 130700,
    description: 'bridge (6/8)'
  },
  {
    trackId: '2iI556oF2qwtac9r1RzrXo',
    start: 54089,
    end: 130700,
    description: 'full first chorus (4/4) + bridge (6/8)'
  }
];

const formatDuration = (ms: number) => {
  if (ms < 0) ms = -ms;
  const time = {
    m: Math.floor(ms / 60000) % 60,
    s: Math.floor(ms / 1000) % 60,
    ms: Math.floor(ms) % 1000
  };

  return `${String(time.m).padStart(2, '0')}:${String(time.s).padStart(2, '0')},${time.ms}`;
};

class Game extends Component {
  @service(SpotifyService) declare spotify: SpotifyService;
  @service(AudioService) declare audio: AudioService;

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
        duration: loop.end - loop.start
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
          <strong>{{item.track.name}}</strong>

          <time>{{formatDuration item.duration}}</time>
          <small>{{formatArtists item.track.artists}}</small>

          {{#if (eq item this.playing)}}
            <button type="button" {{on "click" this.stop}}>Stop</button>
          {{else}}
            <button type="button" {{on "click" (fn this.start item)}}>Start</button>
          {{/if}}

          <span>{{item.description}}</span>


          {{#if item.dev}}
          <div>
          start: <input type="text" value={{item.start}} {{on "change" (fn (pick "target.value" (set item "start")))}}/>
          end: <input type="text" value={{item.end}} {{on "change" (fn (pick "target.value" (set item "end")))}}/>
          </div>
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
