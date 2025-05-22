import Component from '@glimmer/component';
import { cached, tracked } from '@glimmer/tracking';
import { registerDestructor } from '@ember/destroyable';
import { uniqueId } from '@ember/helper';

import { modifier } from 'ember-modifier';

import { dateToMilliseconds, dateToSeconds } from '../../../../../supporting/utils';
import { CATEGORY_GROUPS, type TimeTracking } from './domain';
import { TimelineViewer } from './viewer';

import type { YoutubePlayerAPI } from '../../../../../supporting/youtube';
import type Owner from '@ember/owner';
import type { DataSet } from 'vis-data/esnext';
import type { DataItem, Timeline, TimelineItem, TimelineOptions } from 'vis-timeline/esnext';

interface TimelineEditorSignature {
  Args: {
    active: boolean;
    video?: string;
    playerApi?: YoutubePlayerAPI;
    data?: TimeTracking;
    update?: (data: TimeTracking) => void;
  };
}

export class TimelineEditor extends Component<TimelineEditorSignature> {
  declare player: YoutubePlayerAPI;
  declare chart: Timeline;
  declare data: DataSet<DataItem>;

  @tracked currentTime?: number;

  options: TimelineOptions;

  @cached
  get keys() {
    return CATEGORY_GROUPS.map((g) => g.key);
  }

  running = new Map();

  constructor(owner: Owner, args: TimelineEditorSignature['Args']) {
    super(owner, args);

    this.options = {
      editable: true,
      onMove: this.maybeMerge.bind(this),
      onUpdate: this.handleItemUpdate.bind(this),
      onRemove: this.handleItemUpdate.bind(this)
    };

    try {
      document.body.addEventListener('keyup', this.handleKeyboard.bind(this));

      registerDestructor(this, () => {
        document.body.removeEventListener('keyup', this.handleKeyboard.bind(this));
      });
    } catch {
      /**/
    }
  }

  registerKeyboardShortcuts = modifier((elem: HTMLElement) => {
    elem.addEventListener('keyup', this.handleKeyboard.bind(this));

    return () => {
      elem.removeEventListener('keyup', this.handleKeyboard.bind(this));
    };
  });

  handleItemUpdate = (item: TimelineItem, callback: (item: TimelineItem | null) => void) => {
    callback(item);

    this.processResults();
  };

  processResults = () => {
    const results: TimeTracking = {};

    results.scenes = this.data
      .map((d) => ({
        start: (d.start as number) / 1000,
        end: (d.end as number) / 1000,
        category: d.group
      }))
      .filter((d) => d.category !== 'marker');

    const start = this.data.get('start');

    if (start) {
      results.start = (start.start as number) / 1000;
    }

    const end = this.data.get('end');

    if (end) {
      results.end = (end.start as number) / 1000;
    }

    this.args.update?.(results);
  };

  setPlayerApi = (api: YoutubePlayerAPI) => {
    this.player = api;
  };

  setChartApi = (chart: Timeline, data: DataSet<DataItem>) => {
    this.chart = chart;
    this.data = data;

    this.chart.on('click', (e) => {
      if (e.what === 'group-label') {
        if (e.group === 'marker') {
          this.trackStartStop(this.currentTime as number);
        } else {
          this.track(e.group);
        }
      }
    });

    this.chart.on('timechanged', ({ id, time }: { id: string; time: Date }) => {
      if (id === 'start' || id === 'stop') {
        this.trackStartStop(dateToSeconds(time));
      }
    });
  };

  seeked = (currentTime: number) => {
    this.currentTime = currentTime;

    // update running
    const updates = [];

    for (const datapoints of this.running.values()) {
      updates.push({
        ...datapoints,
        end: currentTime * 1000
      });
    }

    this.data.update(updates);
  };

  handleKeyboard = (event: KeyboardEvent) => {
    if (!this.args.active) {
      return;
    }

    if (this.keys.includes(event.key)) {
      const group = CATEGORY_GROUPS.find((g) => g.key === event.key);

      if (group) {
        this.track(group.id);
      }
    }

    if (event.key === 's' && this.currentTime) {
      this.trackStartStop(this.currentTime);
    }
  };

  trackStartStop = (time: number) => {
    const data = this.args.data ?? ({} as TimeTracking);

    const startExists = data.start !== undefined;
    const endExists = data.end !== undefined;

    if (!data.start) {
      data.start = time;
    } else if (time > data.start) {
      data.end = time;
    } else {
      data.end = data.start;
      data.start = time;
    }

    if (data.start) {
      if (startExists) {
        this.data.update({
          id: 'start',
          start: data.start * 1000
        });
      } else {
        this.data.add({
          id: 'start',
          content: 'Start',
          start: data.start * 1000,
          group: 'marker'
        });
      }
    }

    if (data.end) {
      if (endExists) {
        this.data.update({
          id: 'end',
          start: data.end * 1000
        });
      } else {
        this.data.add({
          id: 'end',
          content: 'Ende',
          start: data.end * 1000,
          group: 'marker'
        });
      }
    }

    this.processResults();
  };

  track = (category: string) => {
    if (this.running.has(category)) {
      const datapoint = this.running.get(category);

      datapoint.end = this.currentTime;

      this.running.delete(category);

      this.processResults();
    } else {
      const datapoint = {
        id: uniqueId(),
        content: '',
        start: (this.currentTime as number) * 1000,
        end: (this.currentTime as number) * 1000,
        group: category
      };

      this.data.add(datapoint);

      this.running.set(category, datapoint);
    }
  };

  maybeMerge = (item: TimelineItem, callback: (item: TimelineItem | null) => void) => {
    if (item.group !== 'marker') {
      const start = (item.start = dateToMilliseconds(item.start as Date));
      const end = (item.end = dateToMilliseconds(item.end as Date));

      const scenes = this.data
        .get({ filter: (i) => i.group === item.group })
        .filter((s) => s.id !== item.id);
      const overlap = scenes.find(
        (s) =>
          (start >= (s.start as number) && start <= (s.end as number)) ||
          (end >= (s.start as number) && end <= (s.end as number))
      );

      if (overlap) {
        item.start = Math.min(start, overlap.start as number);
        item.end = Math.max(end, overlap.end as number);

        this.data.remove(overlap);
      }
    } else {
      item.start = dateToMilliseconds(item.start as Date);
    }

    callback(item);

    this.processResults();
  };

  <template>
    {{#if @playerApi}}
      {{this.setPlayerApi @playerApi}}
    {{/if}}

    <TimelineViewer
      @active={{@active}}
      @data={{@data}}
      @options={{this.options}}
      @playerApi={{@playerApi}}
      @setChartApi={{this.setChartApi}}
      @seeked={{this.seeked}}
    />
  </template>
}
