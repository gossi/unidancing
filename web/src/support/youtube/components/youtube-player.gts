import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';

import { task, timeout } from 'ember-concurrency';
import { modifier } from 'ember-modifier';
import getVideoId from 'get-video-id';
import YTPlayer from 'youtube-player';

import IconPauseFill from '~icons/ph/pause-fill';
import IconPlayFill from '~icons/ph/play-fill';

import { Button, IconButton, RangeInput } from '@hokulea/ember';

import { durationToSeconds, formatDuration, secondsToDuration } from '../../utils';

import type { TaskInstance } from 'ember-concurrency';
import type { Temporal } from 'temporal-polyfill';
import type { YouTubePlayer } from 'youtube-player/dist/types';

// eslint-disable-next-line @typescript-eslint/no-namespace
declare namespace YT {
  enum PlayerState {
    BUFFERING = 3,
    CUED = 5,
    ENDED = 0,
    PAUSED = 2,
    PLAYING = 1,
    UNSTARTED = -1
  }
}

/**
 * https://developers.google.com/youtube/player_parameters#Parameters
 */
interface Parameters {
  autoplay?: 0 | 1 | undefined;

  cc_lang_pref?: string | undefined;

  cc_load_policy?: 1 | undefined;
  color?: 'red' | 'white' | undefined;
  controls?: 0 | 1 | undefined;
  disablekb?: 0 | 1 | undefined;
  enablejsapi?: 0 | 1 | undefined;
  end?: number | undefined;
  fs?: 0 | 1 | undefined;
  hl?: string | undefined;

  iv_load_policy?: 1 | 3 | undefined;
  list?: string | undefined;
  listType?: 'playlist' | 'search' | 'user_uploads' | undefined;
  loop?: 0 | 1 | undefined;
  modestbranding?: 1 | undefined;
  origin?: string | undefined;
  playlist?: string | undefined;
  playsinline?: 0 | 1 | undefined;
  rel?: 0 | 1 | undefined;
  start?: number | undefined;

  widget_referrer?: string | undefined;
}

const DEFAULT_PARAMETERS: Parameters = {
  disablekb: 1,
  controls: 0
};

export type YoutubePlayerAPI = YouTubePlayer & {
  toggle(): void;
  seek(offset: number): void;
  on(event: 'seek', listener: SeekListener): void;
};

type SeekListener = (currentTime: number) => void;

interface YoutubePlayerSignature {
  Element: HTMLIFrameElement;
  Args: {
    url: string;
    options?: Parameters;
    controls?: boolean;
    setApi?: (player: YoutubePlayerAPI) => void;
  };
}

export class YoutubePlayer extends Component<YoutubePlayerSignature> {
  @tracked duration?: Temporal.Duration;
  @tracked currentTime?: Temporal.Duration;

  api?: YoutubePlayerAPI;
  timer?: TaskInstance<void>;
  @tracked playing = false;

  seekListener = new Set<SeekListener>();

  get params(): Parameters {
    return {
      ...DEFAULT_PARAMETERS,
      ...this.args.options
    };
  }

  registerKeyboardShortcuts = modifier((elem: HTMLElement) => {
    const keyboardHandler = this.handleKeyboard.bind(this);

    elem.addEventListener('keyup', keyboardHandler);

    return () => {
      elem.removeEventListener('keyup', keyboardHandler);
    };
  });

  notifySeekListener = (currentTime: number) => {
    for (const listener of this.seekListener) {
      listener(currentTime);
    }
  };

  player = modifier((elem: HTMLElement) => {
    const { id } = getVideoId(this.args.url);

    const player = YTPlayer(elem, {
      videoId: id,
      playerVars: this.params
    });

    void this.load(player);
    this.api = this.proxyApi(player);

    this.args.setApi?.(this.api);

    return () => {
      void player.destroy();
    };
  });

  async load(player: YouTubePlayer) {
    this.duration = secondsToDuration(await player.getDuration());
    this.currentTime = secondsToDuration(await player.getCurrentTime());
  }

  proxyApi(player: YouTubePlayer) {
    // eslint-disable-next-line @typescript-eslint/no-misused-promises
    player.on('stateChange', async ({ data }: { data: YT.PlayerState }) => {
      this.playing = data === YT.PlayerState.PLAYING;

      if (this.playing) {
        // start timers
        this.timer = void this.seeking.perform();
      }

      if ([YT.PlayerState.PAUSED, YT.PlayerState.BUFFERING, YT.PlayerState.ENDED].includes(data)) {
        void this.timer?.cancel();
        this.currentTime = secondsToDuration(await player.getCurrentTime());
        this.notifySeekListener(this.currentTime.total('second'));
      }
    });

    // eslint-disable-next-line @typescript-eslint/no-this-alias, unicorn/no-this-assignment
    const self = this;

    (player as YoutubePlayerAPI).toggle = () => {
      void self.toggle();
    };

    (player as YoutubePlayerAPI).seek = (offset: number) => {
      void self.seek(offset);
    };

    return new Proxy(player, {
      get(target, prop, receiver) {
        // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
        const value = Reflect.get(target, prop, receiver);

        if (prop === 'seekTo') {
          return function (seconds: number, allowSeekAhead: boolean) {
            self.currentTime = secondsToDuration(seconds);
            self.notifySeekListener(seconds);

            // eslint-disable-next-line @typescript-eslint/no-unsafe-return, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
            return value.call(target, seconds, allowSeekAhead);
          };
        }

        if (prop === 'on') {
          return function (event: string, listener: (event: CustomEvent) => void) {
            if (event === 'seek') {
              self.seekListener.add(listener as unknown as SeekListener);
            }

            // eslint-disable-next-line @typescript-eslint/no-unsafe-return, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
            return value.call(target, event, listener);
          };
        }

        if (prop === 'off') {
          return function (event: string, listener: (event: CustomEvent) => void) {
            if (event === 'seek') {
              self.seekListener.delete(listener as unknown as SeekListener);
            }

            // eslint-disable-next-line @typescript-eslint/no-unsafe-return, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
            return value.call(target, event, listener);
          };
        }

        // eslint-disable-next-line @typescript-eslint/no-unsafe-return
        return value;
      }
    }) as YoutubePlayerAPI;
  }

  seeking = task(async () => {
    let counter = 0;

    // eslint-disable-next-line @typescript-eslint/no-unnecessary-condition
    while (true) {
      await timeout(10);
      this.currentTime = this.currentTime?.add({ milliseconds: 10 });

      if (counter === 10) {
        this.currentTime = secondsToDuration(await (this.api as YoutubePlayerAPI).getCurrentTime());
        counter = 0;
      }

      // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
      this.notifySeekListener(this.currentTime!.total('second'));

      counter++;
    }
  });

  seek = async (offset: number) => {
    await this.api?.seekTo(durationToSeconds(this.currentTime) + offset, true);
  };

  seekTo = async (to: number) => {
    await this.api?.seekTo(to, true);
  };

  toggle = async () => {
    if (this.playing) {
      await this.api?.pauseVideo();
    } else {
      await this.api?.playVideo();
    }
  };

  handleKeyboard = (event: KeyboardEvent) => {
    switch (event.key) {
      case ' ': {
        void this.toggle();
        event.preventDefault();
        event.stopPropagation();

        break;
      }

      case 'ArrowRight': {
        if (event.altKey) {
          void this.seek(0.25);
        } else if (event.ctrlKey) {
          void this.seek(1);
        } else if (event.shiftKey) {
          void this.seek(10);
        } else {
          void this.seek(0.1);
        }

        event.preventDefault();
        event.stopPropagation();

        break;
      }

      case 'ArrowLeft': {
        if (event.altKey) {
          void this.seek(-0.25);
        } else if (event.ctrlKey) {
          void this.seek(-1);
        } else if (event.shiftKey) {
          void this.seek(-10);
        } else {
          void this.seek(-0.1);
        }

        event.preventDefault();
        event.stopPropagation();

        break;
      }
    }
  };

  preventDefault = (e: Event) => {
    e.preventDefault();
  };

  <template>
    <div class="player" {{this.registerKeyboardShortcuts}}>
      <div>
        <div {{this.player}}></div>
      </div>

      <RangeInput
        @value={{durationToSeconds this.currentTime}}
        @update={{this.seekTo}}
        class="progress"
        max={{durationToSeconds this.duration}}
        {{on "keyup" this.preventDefault}}
        {{on "keydown" this.preventDefault}}
      />

      {{#if (neq @controls false)}}
        <div class="controls">
          <IconButton
            @spacing="-1"
            @icon={{if this.playing IconPauseFill IconPlayFill}}
            @push={{this.toggle}}
            @label={{if this.playing "pause" "play"}}
          />
          <span class="time">
            {{formatDuration this.currentTime fractionalDigits=3}}
            /
            {{formatDuration this.duration}}
          </span>

          <span class="seek">
            <Button @push={{fn this.seek -10}} @spacing="-1" @importance="plain">-10s</Button>
            <Button @push={{fn this.seek -1}} @spacing="-1" @importance="plain">-1s</Button>
            <Button @push={{fn this.seek -0.25}} @spacing="-1" @importance="plain">-0.25s</Button>
            <Button @push={{fn this.seek -0.1}} @spacing="-1" @importance="plain">-0.1s</Button>

            <Button @push={{fn this.seek 0.1}} @spacing="-1" @importance="plain">+0.1s</Button>
            <Button @push={{fn this.seek 0.25}} @spacing="-1" @importance="plain">+0.25s</Button>
            <Button @push={{fn this.seek 1}} @spacing="-1" @importance="plain">+1s</Button>
            <Button @push={{fn this.seek 10}} @spacing="-1" @importance="plain">+10s</Button>
          </span>
        </div>
      {{/if}}
    </div>
    <style scoped>
      .player {
        /* aspect-ratio: 16 / 9;
        width: 100%; */
        display: flex;
        flex-direction: column;

        & > :first-child {
          overflow: auto;
          resize: vertical;
        }

        :global(iframe) {
          width: 100%;
          min-height: 100%;
        }
      }

      .time {
        font-variant-numeric: tabular-nums;
      }

      .controls {
        display: flex;
        align-items: center;
        gap: var(--spacing-container-1);
      }

      .progress {
        padding-block: var(--spacing-primitive-4);
      }

      .seek {
        margin-inline-start: auto;
        font-size: var(--s-1);

        :global(button) {
          border: 0;
          padding: var(--spacing-primitive-4) !important;
        }
      }
    </style>
  </template>
}
