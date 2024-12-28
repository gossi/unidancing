import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';

import { task, timeout } from 'ember-concurrency';
import { modifier } from 'ember-modifier';
import { notEq } from 'ember-truth-helpers';
import getVideoId from 'get-video-id';
import YTPlayer from 'youtube-player';

import { Button, IconButton, RangeInput } from '@hokulea/ember';

import { durationToSeconds, formatDuration, secondsToDuration } from '../../utils';
import styles from './player.css';

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
  // eslint-disable-next-line @typescript-eslint/naming-convention
  cc_lang_pref?: string | undefined;
  // eslint-disable-next-line @typescript-eslint/naming-convention
  cc_load_policy?: 1 | undefined;
  color?: 'red' | 'white' | undefined;
  controls?: 0 | 1 | undefined;
  disablekb?: 0 | 1 | undefined;
  enablejsapi?: 0 | 1 | undefined;
  end?: number | undefined;
  fs?: 0 | 1 | undefined;
  hl?: string | undefined;
  // eslint-disable-next-line @typescript-eslint/naming-convention
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
  // eslint-disable-next-line @typescript-eslint/naming-convention
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
    elem.addEventListener('keyup', this.handleKeyboard.bind(this));

    return () => {
      elem.removeEventListener('keyup', this.handleKeyboard.bind(this));
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
      player.destroy();
    };
  });

  async load(player: YouTubePlayer) {
    this.duration = secondsToDuration(await player.getDuration());
    this.currentTime = secondsToDuration(await player.getCurrentTime());
  }

  proxyApi(player: YouTubePlayer) {
    player.on('stateChange', async ({ data }) => {
      this.playing = data === YT.PlayerState.PLAYING;

      if (this.playing) {
        // start timer
        this.timer = this.seeking.perform();
      }

      if ([YT.PlayerState.PAUSED, YT.PlayerState.BUFFERING, YT.PlayerState.ENDED].includes(data)) {
        this.timer?.cancel();
        this.currentTime = secondsToDuration(await player.getCurrentTime());
        this.notifySeekListener(this.currentTime.total('second'));
      }
    });

    // eslint-disable-next-line @typescript-eslint/no-this-alias
    const self = this;

    (player as YoutubePlayerAPI).toggle = () => {
      return self.toggle();
    };

    (player as YoutubePlayerAPI).seek = (offset: number) => {
      return self.seek(offset);
    };

    return new Proxy(player, {
      get(target, prop, receiver) {
        const value = Reflect.get(target, prop, receiver);

        if (prop === 'seekTo') {
          return function (seconds: number, allowSeekAhead: boolean) {
            self.currentTime = secondsToDuration(seconds);
            self.notifySeekListener(seconds);

            return value.call(target, seconds, allowSeekAhead);
          };
        }

        if (prop === 'on') {
          return function (event: string, listener: (event: CustomEvent) => void) {
            if (event === 'seek') {
              self.seekListener.add(listener as unknown as SeekListener);
            }

            return value.call(target, event, listener);
          };
        }

        if (prop === 'off') {
          return function (event: string, listener: (event: CustomEvent) => void) {
            if (event === 'seek') {
              self.seekListener.delete(listener as unknown as SeekListener);
            }

            return value.call(target, event, listener);
          };
        }

        return value;
      }
    }) as YoutubePlayerAPI;
  }

  seeking = task(async () => {
    // eslint-disable-next-line no-constant-condition
    while (true) {
      await timeout(10);
      this.currentTime = this.currentTime?.add({ milliseconds: 10 });
      // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
      this.notifySeekListener(this.currentTime!.total('second'));
    }
  });

  seek = (offset: number) => {
    this.api?.seekTo(durationToSeconds(this.currentTime) + offset, true);
  };

  seekTo = (to: number) => {
    this.api?.seekTo(to, true);
  };

  toggle = () => {
    if (this.playing) {
      this.api?.pauseVideo();
    } else {
      this.api?.playVideo();
    }
  };

  handleKeyboard = (event: KeyboardEvent) => {
    switch (event.key) {
      case ' ':
        this.toggle();
        event.preventDefault();
        event.stopPropagation();

        break;

      case 'ArrowRight':
        if (event.altKey) {
          this.seek(0.25);
        } else if (event.ctrlKey) {
          this.seek(1);
        } else if (event.shiftKey) {
          this.seek(10);
        } else {
          this.seek(0.1);
        }

        event.preventDefault();
        event.stopPropagation();

        break;

      case 'ArrowLeft':
        if (event.altKey) {
          this.seek(-0.25);
        } else if (event.ctrlKey) {
          this.seek(-1);
        } else if (event.shiftKey) {
          this.seek(-10);
        } else {
          this.seek(-0.1);
        }

        event.preventDefault();
        event.stopPropagation();

        break;
    }
  };

  preventDefault = (e: Event) => {
    e.preventDefault();
  };

  <template>
    <div class={{styles.player}} {{this.registerKeyboardShortcuts}}>
      <div {{this.player}}></div>

      <RangeInput
        @value={{durationToSeconds this.currentTime}}
        @update={{this.seekTo}}
        class={{styles.progress}}
        max={{durationToSeconds this.duration}}
        {{on "keyup" this.preventDefault}}
        {{on "keydown" this.preventDefault}}
      />

      {{#if (notEq @controls false)}}
        <div class={{styles.controls}}>
          <IconButton
            @spacing="-1"
            @icon={{if this.playing "pause" "play"}}
            @iconStyle="fill"
            @push={{this.toggle}}
            @label={{if this.playing "pause" "play"}}
          />
          <span class={{styles.time}}>
            {{formatDuration this.currentTime fractionalDigits=3}}
            /
            {{formatDuration this.duration}}
          </span>

          <span class={{styles.seek}}>
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
  </template>
}
