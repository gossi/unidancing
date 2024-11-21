import Component from '@glimmer/component';
import { concat } from '@ember/helper';
import { hash } from '@ember/helper';

import { tracked as deepTracked } from 'ember-deep-tracked';
import { formatNumber, t } from 'ember-intl';
import { service } from 'ember-polaris-service';

import { Form } from '@hokulea/ember';

import { CardSection, Features } from '../../../supporting/ui';
import { YoutubePlayer, YoutubeService } from '../../../supporting/youtube';
import { CriterionInterval, Score } from './-components';
import { toIntlNameKey } from './-utils';
import { extractWireData, getCriterionKey, loadSystem, scoreCategory, scorePart } from './actions';
import styles from './routines.css';
import { IUF_PERFORMANCE_2019 } from './systems/iuf-performance-2019';

import type {
  JudgingSystem,
  JudgingSystemCategory,
  JudgingSystemCriterion,
  JudgingSystemPart,
  RoutineTest
} from './domain-objects';
import type { TOC } from '@ember/component/template-only';
import type Owner from '@ember/owner';
import type { FormBuilder } from '@hokulea/ember';

/* eslint-disable @typescript-eslint/naming-convention */
interface Data {
  rider: string;
  event: string;
  video: string;
  'artistic-performance-execution-presence': number;
  'artistic-performance-execution-carriage': number;
  'artistic-performance-execution-authenticity': number;
  'artistic-performance-execution-clarity': number;
  'artistic-performance-execution-variety': number;
  'artistic-performance-execution-projection': number;
  'artistic-performance-choreography-purpose': number;
  'artistic-performance-choreography-harmony': number;
  'artistic-performance-choreography-utilization': number;
  'artistic-performance-choreography-dynamics': number;
  'artistic-performance-choreography-imaginativeness': number;
  'artistic-performance-music-realization': number;
  'artistic-performance-music-expression': number;
  'artistic-performance-music-finesse': number;
  'artistic-performance-music-timing': number;
}
/* eslint-enable @typescript-eslint/naming-convention */

function toDataKey(name: string) {
  return ('artistic-' + name.replaceAll('.', '-')) as keyof Data;
}

function parseFormData(system: JudgingSystem, data: Data): JudgingSystem {
  const results = {
    ...system,
    parts: system.parts.map((part) => ({
      ...part,
      categories: part.categories.map((category) => ({
        ...category,
        criteria: category.criteria.map((criterion) => ({
          ...criterion,
          value: data[toDataKey(getCriterionKey(criterion))] as number
        }))
      }))
    }))
  };

  return results;
}

class Criterion extends Component<{
  Args: {
    form: FormBuilder<Data, void>;
    criterion: JudgingSystemCriterion;
  };
}> {
  get name() {
    return `artistic-${getCriterionKey(this.args.criterion).replaceAll('.', '-')}` as keyof Data;
  }

  <template>
    {{#let @form as |f|}}
      <f.Range
        @name={{this.name}}
        @label={{concat
          (t (toIntlNameKey this.name))
          (if @criterion.value (concat " (" (formatNumber @criterion.value) ")") "")
        }}
        min="0"
        max="10"
        step="0.1"
      />

      {{#if @criterion.value}}
        <CriterionInterval @criterion={{@criterion}} />
      {{/if}}
    {{/let}}
  </template>
}

class Category extends Component<{
  Args: {
    form: FormBuilder<Data, void>;
    system: JudgingSystem;
    category: JudgingSystemCategory;
  };
}> {
  get name() {
    return `artistic-${this.args.category.part.name}-${this.args.category.name}`;
  }

  get score() {
    return scoreCategory(this.args.category);
  }

  <template>
    <CardSection class={{styles.category}}>
      <:header>
        <hgroup>
          <h4>{{t (toIntlNameKey this.name)}}</h4>
          <p>
            <span class={{styles.score}} data-score="label">Score:</span>
            <Score @score={{this.score}} />
          </p>
        </hgroup>
      </:header>
      <:body>
        {{#each @category.criteria as |criterion|}}
          <Criterion @form={{@form}} @criterion={{criterion}} />
        {{/each}}
      </:body>
    </CardSection>
  </template>
}

const Part: TOC<{
  Args: {
    form: FormBuilder<Data, void>;
    system: JudgingSystem;
    part: JudgingSystemPart;
  };
}> = <template>
  <Features>
    {{#each @part.categories as |category|}}
      <Category @form={{@form}} @system={{@system}} @category={{category}} />
    {{/each}}
  </Features>
</template>;

class Artistic extends Component<{
  Args: { form: FormBuilder<Data, void>; system: JudgingSystem };
}> {
  get score() {
    const partResults = this.args.system.parts.find(
      (p) => p.name === 'performance'
    ) as JudgingSystemPart;

    return scorePart(partResults);
  }

  <template>
    <h2>Artistik</h2>
    <p>
      <span class={{styles.score}} data-score="label">Score:</span>
      <Score @score={{this.score}} />
    </p>

    {{#each @system.parts as |part|}}
      <Part @form={{@form}} @system={{@system}} @part={{part}} />
    {{/each}}
  </template>
}

interface RoutineTesterFormArgs {
  data?: RoutineTest;
  submit: (data: RoutineTest) => void;
}

export class RoutineTesterForm extends Component<{
  Args: RoutineTesterFormArgs;
}> {
  @service(YoutubeService) declare youtube: YoutubeService;

  Form = Form<Data, void>;

  @deepTracked artistic: JudgingSystem;

  /* eslint-disable @typescript-eslint/naming-convention */
  data: Data = {
    rider: '',
    event: '',
    video: '',
    'artistic-performance-execution-presence': 0,
    'artistic-performance-execution-carriage': 0,
    'artistic-performance-execution-authenticity': 0,
    'artistic-performance-execution-clarity': 0,
    'artistic-performance-execution-variety': 0,
    'artistic-performance-execution-projection': 0,
    'artistic-performance-choreography-purpose': 0,
    'artistic-performance-choreography-harmony': 0,
    'artistic-performance-choreography-utilization': 0,
    'artistic-performance-choreography-dynamics': 0,
    'artistic-performance-choreography-imaginativeness': 0,
    'artistic-performance-music-realization': 0,
    'artistic-performance-music-expression': 0,
    'artistic-performance-music-finesse': 0,
    'artistic-performance-music-timing': 0
  };
  /* eslint-enable @typescript-eslint/naming-convention */

  constructor(owner: Owner, args: RoutineTesterFormArgs) {
    super(owner, args);

    // return video.snippet.resourceId.url;

    this.artistic = loadSystem(IUF_PERFORMANCE_2019, args.data?.artistic);

    if (args.data) {
      this.loadData(args.data);
    }

    this.getVideoUrl('Y3al545mkR4');
  }

  loadData(data: RoutineTest) {
    this.data.rider = data.rider;
    this.data.event = data.event as string;
    this.data.video = data.video as string;

    for (const p of this.artistic.parts) {
      for (const c of p.categories) {
        for (const cr of c.criteria) {
          const key = toDataKey(getCriterionKey(cr)) as keyof Data;

          // eslint-disable-next-line @typescript-eslint/ban-ts-comment
          // @ts-ignore
          this.data[key] = cr.value;
        }
      }
    }
  }

  async getVideoUrl(videoId: string) {
    const video = await this.youtube.getVideo(videoId, {
      fields: 'items(snippet/title,contentDetails/duration)'
    });

    console.log(video);
    // const yt = youtube('v3');
    // const res = await yt.videos.list({
    //   part: 'snippet,contentDetails',
    //   id: videoId
    // });
    // const video = res.data.items[0];
    // return video.snippet.resourceId.url;
  }

  updateCriterionValues = (data: Data) => {
    for (const p of this.artistic.parts) {
      for (const c of p.categories) {
        for (const cr of c.criteria) {
          cr.value = data[toDataKey(getCriterionKey(cr))] as number;
        }
      }
    }
  };

  updateJudgingSystemResults = (data: Data) => {
    this.updateCriterionValues(data);

    return undefined;
  };

  submit = (data: Data) => {
    const artistic = extractWireData(parseFormData(this.artistic, data));
    const routine: RoutineTest = {
      rider: data.rider,
      event: data.event,
      video: data.video,
      artistic
    };

    this.args.submit(routine);
  };

  <template>
    <this.Form
      @data={{this.data}}
      @validateOn="change"
      @validate={{this.updateJudgingSystemResults}}
      @submit={{this.submit}}
      as |f|
    >
      <h2>Kür</h2>
      <YoutubePlayer
        @url="https://www.youtube.com/watch?v=Y3al545mkR4"
        @options={{hash controls=0}}
      />
      <f.Text @name="rider" @label="Fahrer" />
      <f.Text @name="event" @label="Veranstaltung" />
      <f.Text @name="video" @label="Video" placeholder="YouTube URL" />

      <Artistic @form={{f}} @system={{this.artistic}} />

      <f.Submit>Ergebnisse anzeigen</f.Submit>
    </this.Form>
  </template>
}
