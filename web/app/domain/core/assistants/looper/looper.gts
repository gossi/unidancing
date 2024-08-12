import Component from '@glimmer/component';
import { cached, tracked } from '@glimmer/tracking';
import { registerDestructor } from '@ember/destroyable';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';

import { ability } from 'ember-ability';
import { action } from 'ember-command';
import { restartableTask, timeout } from 'ember-concurrency';
import { modifier } from 'ember-modifier';
import Service, { service } from 'ember-polaris-service';
import { resource, resourceFactory, use } from 'ember-resources';
import Task from 'ember-tasks';

import { Form } from '@hokulea/ember';

import { AudioPlayer, AudioService } from '../../../supporting/audio';
import {
  findTrack,
  formatArtists,
  isAuthenticated,
  MaybeSpotifyPlayerWarning,
  SpotifyPlayButton,
  SpotifyService,
  WithSpotify
} from '../../../supporting/spotify';
import { data } from './data';
import styles from './looper.css';

import type { Track } from '../../../supporting/spotify';
import type { LoopDescriptor, LoopTrackDescriptor } from './data';
import type { TOC } from '@ember/component/template-only';

const DEV = false;

// describing the raw data

interface LoopData extends LoopDescriptor {
  name: string;
  duration: number;
  track: Track;
  id: string;
}

interface LoopTrackData extends LoopTrackDescriptor {
  track: Track;
  loops: LoopData[];
}

export const loadLoop = resourceFactory((loop: LoopTrackDescriptor) => {
  return resource(async ({ use: useResource }): Promise<LoopTrackData> => {
    const track = await useResource(findTrack(loop.trackId)).current;

    return {
      ...loop,
      track,
      loops: loop.loops.map((lp) => {
        return {
          id: loop.id,
          track,
          ...lp,
          name: lp.name ?? 'default',
          duration: lp.end - lp.start
        };
      })
    };
  });
});

class LoopService extends Service {
  @service(SpotifyService) declare spotify: SpotifyService;

  @tracked latency = 250;
  @tracked playing?: LoopData;
  @tracked elapsedTime = 0;

  start = async (loop: LoopData, offset?: number) => {
    this.playing = loop;

    try {
      await this.play.perform(loop, offset);
      // eslint-disable-next-line no-empty
    } catch {}
  };

  play = restartableTask(async (loop: LoopData, offset?: number) => {
    this.spotify.client.selectTrack(loop.track);

    let max = loop.end - loop.start - this.latency;

    this.elapsedTime = offset ? (offset < 0 ? max + offset : offset) : 0;

    // eslint-disable-next-line no-constant-condition
    while (true) {
      await this.spotify.client.play({
        uris: [loop.track.uri],
        // eslint-disable-next-line @typescript-eslint/naming-convention
        position_ms: loop.start + this.elapsedTime // elapsed time includes the duration offset
      });

      while (this.elapsedTime < max) {
        max = loop.end - loop.start - this.latency;

        const rest = max - this.elapsedTime;
        const tick = rest <= 2000 ? rest : 1000;

        this.elapsedTime += tick;

        await timeout(tick);
      }

      this.elapsedTime = 0;
    }
  });

  stop = async () => {
    await this.play.last?.cancel();
    await this.spotify.client.pause();
    this.playing = undefined;
  };
}

const start = action(({ service }) => async (loop: LoopData, offset: number = 0) => {
  const loopService = service(LoopService);

  await loopService.start(loop, offset);
});

const stop = action(({ service }) => async () => {
  const loopService = service(LoopService);

  await loopService.stop();
});

const isPlaying = ability(({ service }) => (loop: LoopData) => {
  const loopService = service(LoopService);

  return loopService.playing === loop;
});

const playingPercentage = ability(({ service }) => () => {
  const loopService = service(LoopService);

  if (!loopService.playing) {
    return 0;
  }

  return Math.round((loopService.elapsedTime / loopService.playing.duration) * 100);
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
  };

  get data() {
    return {
      latency: this.loop.latency
    };
  }

  <template>
    <details>
      <summary>Einstellungen</summary>

      <Form @data={{this.loop}} @dataMode="mutable" as |f|>
        <f.Number @name="latency" @label="Latenz [ms]" />
      </Form>
    </details>
  </template>
}

interface PlayButtonSignature {
  Args: {
    loop: LoopData;
  };
}

const PlayButton: TOC<PlayButtonSignature> = <template>
  {{#if (isPlaying @loop)}}
    <SpotifyPlayButton
      @intent="stop"
      class={{styles.playbutton}}
      data-playing
      {{on "click" (stop)}}
      {{applyPercentage (playingPercentage)}}
    >
      Stop
    </SpotifyPlayButton>
  {{else}}
    <SpotifyPlayButton class={{styles.playbutton}} {{on "click" (fn (start) @loop 0)}}>
      Play
    </SpotifyPlayButton>
  {{/if}}
</template>;

interface LoopSignature {
  Args: {
    track: LoopTrackDescriptor;
    loop?: string;
  };
}

class Loop extends Component<LoopSignature> {
  @service(LoopService) declare loop: LoopService;
  @service(AudioService) declare audio: AudioService;

  loaded = false;

  constructor(owner: unknown, args: LoopSignature['Args']) {
    super(owner, args);

    this.audio.player = AudioPlayer.Spotify;

    registerDestructor(this, () => {
      this.audio.player = undefined;

      if (this.loaded && this.load.resolved) {
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
    const promise = use(this, loadLoop(this.args.track)).current;

    // eslint-disable-next-line ember/no-side-effects
    this.loaded = true;

    return Task.promise(promise);
  }

  // eslint-disable-next-line @typescript-eslint/ban-ts-comment
  // @ts-ignore
  getLoop = (track: LoopTrackData) => {
    if (track.loops.length === 1) {
      return track.loops[0];
    } else if (this.args.loop) {
      return track.loops.find((loop) => loop.name === this.args.loop);
    }
  };

  <template>
    {{#if (isAuthenticated)}}
      {{#let this.load as |r|}}
        {{#if r.resolved}}
          {{#let (this.getLoop r.value) as |l|}}
            {{#if l}}
              <PlayButton @loop={{l}} />
            {{/if}}
          {{/let}}
        {{/if}}
      {{/let}}
    {{else}}
      Login mit Spotify
    {{/if}}
  </template>
}

interface LoopCardSignature {
  Args: {
    loop: LoopTrackDescriptor;
  };
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
                <PlayButton @loop={{loop}} />
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

  constructor(owner: unknown, args: object) {
    super(owner, args);

    this.audio.player = AudioPlayer.Spotify;

    registerDestructor(this, () => {
      this.audio.player = undefined;
    });
  }

  <template>
    <Latency />

    <MaybeSpotifyPlayerWarning />

    {{#each data as |loop|}}
      <LoopCard @loop={{loop}} />
    {{/each}}
  </template>
}

const Looper: TOC<object> = <template>
  <h1>Loops</h1>

  <WithSpotify>
    <Game />
  </WithSpotify>
</template>;

export { Loop, Looper };
