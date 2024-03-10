import Component from '@glimmer/component';
import { cached, tracked } from '@glimmer/tracking';
import { dropTask, timeout } from 'ember-concurrency';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import styles from './looper.css';
import { registerDestructor } from '@ember/destroyable';
import Service, { service } from 'ember-polaris-service';
import { AudioPlayer, AudioService } from '../../../supporting/audio';
import {
  WithSpotify,
  SpotifyService,
  formatArtists,
  findTrack,
  SpotifyPlayButton
} from '../../../supporting/spotify';
import type { Track } from '../../../supporting/spotify';
import type { TOC } from '@ember/component/template-only';
import { resource, resourceFactory, use } from 'ember-resources';
import Task from 'ember-tasks';
import { action } from 'ember-command';
import { ability } from 'ember-ability';
import { modifier } from 'ember-modifier';

const DEV = false;

// describing the raw data

interface RawLoopDescriptor {
  name?: string;
  start: number;
  end: number;
  description?: string;
}

interface RawLoopTrackDescriptor {
  id: string;
  trackId: string;
  loops: RawLoopDescriptor[];
}

interface LoopData extends RawLoopDescriptor {
  name: string;
  duration: number;
  track: Track;
  id: string;
}

interface LoopTrackData extends RawLoopTrackDescriptor {
  track: Track;
  loops: LoopData[];
}

type Loops = RawLoopTrackDescriptor[];

export const loadLoop = resourceFactory((loop: RawLoopTrackDescriptor) => {
  return resource(async ({ use }): Promise<LoopTrackData> => {
    const track = await use(findTrack(loop.trackId)).current;

    return {
      ...loop,
      track,
      loops: loop.loops.map(lp => {
        return {
          id: loop.id,
          track,
          ...lp,
          name: lp.name ?? 'default',
          duration: lp.end - lp.start
        }
      })
    };
  });
});

const data: Loops = [
  // Radioactive by Imagine Dragons
  {
    "id": "radioactive",
    "trackId": "69yfbpvmkIaB10msnKT7Q5",
    "loops": [
      {
        "start": 27787,
        "end": 82648,
        "description": "verse + chorus"
      }
    ]
  },
  // Vikings - Axe and Sword
  // https://open.spotify.com/track/4SnaUdWZrAIfmvwdclYWhn
  // {
  //   start: 82000,
  //   end: 115000,
  //   trackId: '4SnaUdWZrAIfmvwdclYWhn'
  // }
  // The Call
  // https://open.spotify.com/track/2iI556oF2qwtac9r1RzrXo
  {
    "id": "the-call",
    "trackId": "2iI556oF2qwtac9r1RzrXo",
    "loops": [
      {
        "name": "half-chorus+bridge",
        "start": 70000,
        "end": 130700,
        "description": "half first chorus (4/4) + bridge (6/8)"
      },
      {
        "name": "bridge",
        "start": 90100,
        "end": 130700,
        "description": "bridge (6/8)"
      },
      {
        "name": "chorus+bridge",
        "start": 54089,
        "end": 130700,
        "description": "full first chorus (4/4) + bridge (6/8)"
      }
    ]
  },
  // Underground by Lindsey Stirling
  // https://open.spotify.com//track/2vcEiEb8cTgyeb0biKChCY
  {
    id: 'underground',
    trackId: '2vcEiEb8cTgyeb0biKChCY',
    loops: [
      {
        start: 63692,
        end: 130065
      }
    ]
  },
  // Drakenblade by Epic North, Pauli Hausmann
  // https://open.spotify.com/track/7uKw84AAmdvMIdxNyMmhSi
  {
    id: 'drakenblade',
    trackId: '7uKw84AAmdvMIdxNyMmhSi',
    loops: [
      {
        start: 96859,
        end: 149846 // 149846
      }
    ]
  }
];

class LoopService extends Service {
  @service(SpotifyService) declare spotify: SpotifyService;

  @tracked latency = 250;
  @tracked playing?: LoopData;
  @tracked elapsedTime = 0;

  start = async (loop: LoopData, offset?: number) => {
    if (this.playing) {
      await this.stop();
    }

    this.playing = loop;

    try {
      await this.play.perform(loop, offset);
    } catch(_) {}
  }

  play = dropTask(async (loop: LoopData, offset?: number) => {
    this.spotify.client.selectTrack(loop.track);

    let max = (loop.end - loop.start) - this.latency;
    this.elapsedTime = offset ? (offset < 0 ? max + offset : offset) : 0;

    while (true) {
      await this.spotify.client.play({
        uris: [loop.track.uri],
        position_ms: loop.start + this.elapsedTime // elapsed time includes the duration offset
      });

      while (this.elapsedTime < max) {
        max = (loop.end - loop.start) - this.latency;
        const rest = max - this.elapsedTime;
        const tick = rest <= 2000 ? rest : 1000;
        this.elapsedTime += tick;

        await timeout(tick);
      }

      this.elapsedTime = 0;
    }
  });

  stop = async () => {
    await this.play.cancelAll();
    await this.spotify.client.pause();
    this.playing = undefined;
  };
}

const start = action(({ service }) => (loop: LoopData, offset: number = 0) => {
  const loopService = service(LoopService);
  loopService.start(loop, offset);
});

const stop = action(({ service }) => () => {
  const loopService = service(LoopService);
  loopService.stop();
});

const isPlaying = ability(({ service }) =>  (loop: LoopData) => {
  const loopService = service(LoopService);
  return loopService.playing === loop;
});

const playingPercentage = ability(({ service }) =>  () => {
  const loopService = service(LoopService);

  if (!loopService.playing) {
    return 0;
  }

  return Math.round(loopService.elapsedTime / loopService.playing.duration * 100);
});

const applyPercentage = modifier((element, [percentage]) => {
  (element as HTMLElement).style.setProperty('--percent', `${percentage}%`);
});

const formatDuration = (ms: number) => {
  if (ms < 0) ms = -ms;
  const time = {
    m: Math.floor(ms / 60000) % 60,
    s: Math.floor(ms / 1000) % 60,
    ms: Math.floor(ms) % 1000
  };

  return `${String(time.m).padStart(2, '0')}:${String(time.s).padStart(2, '0')},${time.ms}`;
};

class Latency extends Component {
  @service(LoopService) declare loop: LoopService;

  updateLatency = (event: Event) => {
    this.loop.latency = Number.parseFloat((event.target as HTMLInputElement).value);
  }

  <template>
    <label>
      Latenz [ms]
      <input type="text" value={{this.loop.latency}} {{on "change" this.updateLatency}}>
    </label>
  </template>
}

interface PlayButtonSignature {
  Args: {
    loop: LoopData;
  }
}

class PlayButton extends Component<PlayButtonSignature> {
  <template>
    <SpotifyPlayButton
      @playing={{(isPlaying @loop)}}
      class={{styles.playbutton}}
      {{on "click" (if (isPlaying @loop) (stop) (fn (start) @loop 0))}}
      {{!@glint-ignore}}
      {{(if (isPlaying @loop) (modifier applyPercentage (playingPercentage)))}}
    >
      {{#if (isPlaying @loop)}}
        Stop
      {{else}}
        Play
      {{/if}}
    </SpotifyPlayButton>
    {{!-- {{#if (isPlaying @loop)}}
      <SpotifyPlayButton class={{styles.playbutton}} {{on "click" (stop)}}
      data-playing {{applyPercentage (playingPercentage)}}>Stop</SpotifyPlayButton>
    {{else}}
      <SpotifyPlayButton class={{styles.playbutton}} {{on "click" (fn (start) @loop 0)}}>Start</SpotifyPlayButton>
    {{/if}} --}}
  </template>
}

interface LoopCardSignature {
  Args: {
    loop: RawLoopTrackDescriptor;
  }
}

class LoopCard extends Component<LoopCardSignature> {
  @service(LoopService) declare loop: LoopService;

  constructor(owner: unknown, args: LoopCardSignature['Args']) {
    super(owner, args);

    registerDestructor(this, () => {
      if (this.load.resolved) {
        for (const loop of this.load.value.loops) {
          if (this.loop.playing === loop) {
            this.loop.stop();
          }
        }
      }
    });
  }

  @cached
  get load() {
    const promise = use(this, loadLoop(this.args.loop)).current;

    return Task.promise(promise);
  }

  <template>
    <article class={{styles.card}}>
      {{#let this.load as |r|}}
        {{#if r.resolved}}
          <div class={{styles.header}}>
            <strong>{{r.value.track.name}}</strong>
            <small>{{formatArtists r.value.track.artists}}</small>
          </div>

          {{#each r.value.loops as |loop|}}
            <div class={{styles.loop}}>
              <div>
                <time>{{formatDuration loop.duration}}</time>
                <span>{{loop.description}}</span>
              </div>

              <div class={{styles.buttons}}>
                {{#if DEV}}
                  <SpotifyPlayButton {{on "click" (fn (start) loop -10000)}}>-10</SpotifyPlayButton>
                  <SpotifyPlayButton {{on "click" (fn (start) loop -5000)}}>-5</SpotifyPlayButton>
                {{/if}}
                <PlayButton @loop={{loop}}/>
              </div>
            </div>
          {{/each}}
        {{/if}}
      {{/let}}
    </article>
  </template>
}

class Game extends Component {
  @service(AudioService) declare audio: AudioService;

  constructor(owner: unknown, args: {}) {
    super(owner, args);

    this.audio.player = AudioPlayer.Spotify;

    registerDestructor(this, () => {
      this.audio.player = undefined;
    });
  }

  <template>
    <Latency />

    {{#each data as |loop|}}
      <LoopCard @loop={{loop}}/>
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
