import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { registerDestructor } from '@ember/destroyable';
import { uniqueId } from '@ember/helper';

import { modifier } from 'ember-modifier';
import { DataSet } from 'vis-data/esnext';
import { Timeline } from 'vis-timeline/esnext';

import { dateToSecondsWithMilli } from '../../../../../supporting/utils';
import { YoutubePlayer } from '../../../../../supporting/youtube';
import { GROUPS, type TimeTracking } from './domain';

import type { YoutubePlayerAPI } from '../../../../../supporting/youtube';
import type Owner from '@ember/owner';
import type { DataItem, TimelineEventPropertiesResult, TimelineOptions } from 'vis-timeline/esnext';

interface TimelineViewerSignature {
  Element: HTMLElement;
  Args: {
    active: boolean;
    data?: TimeTracking;
    options?: TimelineOptions;
    video?: string;
    redraw?: boolean;
    playerApi?: YoutubePlayerAPI;
    setChartApi?: (chart: Timeline, data: DataSet<DataItem>) => void;
    seeked?: (currentTime: number) => void;
  };
}

export class TimelineViewer extends Component<TimelineViewerSignature> {
  declare player: YoutubePlayerAPI;
  declare chart: Timeline;

  @tracked duration?: number;
  @tracked currentTime?: number;

  data = new DataSet<DataItem>();

  constructor(owner: Owner, args: TimelineViewerSignature['Args']) {
    super(owner, args);

    try {
      const keyboardHandler = this.handleKeyboard.bind(this);

      document.body.addEventListener('keydown', keyboardHandler);

      registerDestructor(this, () => {
        document.body.removeEventListener('keydown', keyboardHandler);
      });
    } catch {
      /**/
    }
  }

  setPlayerApi = (api: YoutubePlayerAPI) => {
    this.player = api;
    this.player.on('seek', this.seeked.bind(this));

    void this.init();
  };

  init = async () => {
    this.duration = await this.player.getDuration();
    this.currentTime = await this.player.getCurrentTime();

    this.chart.setOptions({
      end: this.duration * 1000,
      max: this.duration * 1000,
      zoomMax: this.duration * 1000
    });

    const seek = ({ id, time }: { id: string; time: Date }) => {
      // eslint-disable-next-line unicorn/prefer-early-return
      if (id === 'currentTime') {
        const ms = dateToSecondsWithMilli(time);

        const seekTo = ms <= 0 ? 0 : Math.min(ms, this.duration as number);

        if (ms <= 0) {
          this.chart.setCustomTime(0, 'currentTime');
        } else if (ms >= (this.duration as number)) {
          this.chart.setCustomTime((this.duration as number) * 1000, 'currentTime');
        } else {
          void this.player.seekTo(seekTo, true);
        }
      }
    };

    this.chart.on('timechange', seek);
    this.chart.on('timechanged', seek);

    this.data.add(
      (this.args.data?.scenes ?? []).map((v) => ({
        id: uniqueId(),
        content: '',
        start: v.start * 1000,
        end: v.end * 1000,
        group: v.category
      }))
    );

    if (this.args.data?.start) {
      this.data.add({
        id: 'start',
        content: 'Start',
        start: this.args.data.start * 1000,
        group: 'marker'
      });
    }

    if (this.args.data?.end) {
      this.data.add({
        id: 'end',
        content: 'Ende',
        start: this.args.data.end * 1000,
        group: 'marker'
      });
    }
  };

  seeked = (currentTime: number) => {
    this.currentTime = currentTime;

    // move cursor
    this.chart.setCustomTime(currentTime * 1000, 'currentTime');
    // this.chart.setCurrentTime(currentTime * 1000);

    this.args.seeked?.(currentTime);
  };

  timeline = modifier((element: HTMLElement) => {
    this.chart = new Timeline(element, this.data, GROUPS, {
      start: 0,
      min: 0,
      zoomMin: 0,
      orientation: 'top',
      showCurrentTime: false,
      showMajorLabels: false,
      format: {
        minorLabels: (date: Date, scale: string /* , step */) => {
          return Intl.DateTimeFormat('de', {
            dateStyle: undefined,
            hour: undefined,
            minute: '2-digit',
            second: '2-digit',
            ...(scale === 'millisecond' && {
              fractionalSecondDigits: 3
            })
          }).format(date);
        }
      },
      ...this.args.options
    });

    this.chart.addCustomTime(0, 'currentTime');
    this.chart.setCustomTimeTitle('', 'currentTime');

    this.chart.on('click', (e: TimelineEventPropertiesResult) => {
      element.focus();

      if (e.what === 'background') {
        void this.player.seekTo(dateToSecondsWithMilli(e.time), true);
      }
    });

    this.args.setChartApi?.(this.chart, this.data);

    return () => {
      this.chart.destroy();
    };
  });

  handleKeyboard = (event: KeyboardEvent) => {
    if (!this.args.active) {
      return;
    }

    switch (event.key) {
      case ' ': {
        this.player.toggle();
        event.preventDefault();
        event.stopPropagation();

        break;
      }

      case 'ArrowRight': {
        if (event.altKey) {
          this.player.seek(0.25);
        } else if (event.ctrlKey) {
          this.player.seek(1);
        } else if (event.shiftKey) {
          this.player.seek(10);
        } else {
          this.player.seek(0.1);
        }

        event.preventDefault();
        event.stopPropagation();

        break;
      }

      case 'ArrowLeft': {
        if (event.altKey) {
          this.player.seek(-0.25);
        } else if (event.ctrlKey) {
          this.player.seek(-1);
        } else if (event.shiftKey) {
          this.player.seek(-10);
        } else {
          this.player.seek(-0.1);
        }

        event.preventDefault();
        event.stopPropagation();

        break;
      }
    }
  };

  <template>
    {{#if @playerApi}}
      {{this.setPlayerApi @playerApi}}
    {{else if @video}}
      <YoutubePlayer @url={{@video}} @controls={{true}} @setApi={{this.setPlayerApi}} />
    {{/if}}

    <div tabindex="0" class="timeline" {{this.timeline}}></div>

    <style scoped>
      .timeline {
        :global(svg) {
          background: none !important;
        }

        :global(.vis-timeline > .vis-background:first-child) {
          background-color: var(--surface-container1);
        }

        :global(.vis-time-axis.vis-background) {
          background-color: var(--surface-container);
        }

        :global(.vis-label) {
          border-color: var(--control-border-color);
          color: var(--typography-subtle);
        }

        :global(.vis-text) {
          border-right: 0.5px solid var(--control-border-color);
          color: var(--typography-muted);
          background-color: var(--surface-container1);
        }

        :global(.vis-panel),
        :global(.vis-timeline),
        :global(.vis-group) {
          border-color: var(--control-border-color);
        }

        :global(.vis-time-axis .vis-grid.vis-vertical) {
          border-left: 0.5px solid hsl(from var(--control-border-color) h s calc(l - 5));
        }

        :global(.vis-group:first-child .vis-item) {
          margin-top: -15px;
        }

        :global(.marker .vis-item) {
          border-color: var(--shape-stroke-color);
          color: var(--typography-main);
          background-color: var(--surface-popover);
        }

        :global(.artistry .vis-item) {
          border-color: var(--artistry);
          background-color: var(--artistry);
        }

        :global(.communication .vis-item) {
          border-color: var(--comm);
          background-color: var(--comm);
        }

        :global(.tricks .vis-item) {
          border-color: var(--tricks);
          background-color: var(--tricks);
        }

        :global(.filler .vis-item) {
          border-color: var(--filler);
          background-color: var(--filler);
        }

        :global(.void .vis-item) {
          border-color: var(--void);
          background-color: var(--void);
        }

        :global(.dismounts .vis-item) {
          border-color: var(--dismounts);
          background-color: var(--dismounts);
        }

        :global(.vis-item.vis-selected) {
          border-color: var(--control-border-color);
          background-color: var(--control-focus-selected-background);
        }
      }
    </style>
  </template>
}
