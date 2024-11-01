import Component from '@glimmer/component';

import { Form } from '@hokulea/ember';

import { judgingSystem } from './judging-system-2019';

import type {
  JudgingSystem,
  JudgingSystemCategory,
  JudgingSystemCriterion,
  JudgingSystemPart,
  WireJudgingSystemResults
} from './domain-objects';

interface Data {
  artistic?: WireJudgingSystemResults;
}

class Criterion extends Component<{
  Args: {
    form: Form;
    criterion: JudgingSystemCriterion;
    category: JudgingSystemCategory;
    part: JudgingSystemPart;
  };
}> {
  get name() {
    return `artistic-${this.args.part.name}-${this.args.category.name}-${this.args.criterion.name}`;
  }

  <template>
    {{#let @form as |f|}}
      <f.Number @name={{this.name}} @label={{@criterion.name}} />
    {{/let}}
  </template>
}

class Category extends Component<{
  Args: { form: Form; category: JudgingSystemCategory; part: JudgingSystemPart };
}> {
  <template>
    {{@category.name}}

    {{#each @category.criteria as |criterion|}}
      <Criterion @form={{@form}} @criterion={{criterion}} @category={{@category}} @part={{@part}} />
    {{/each}}
  </template>
}

class Part extends Component<{ Args: { form: Form; part: JudgingSystemPart } }> {
  <template>
    {{#each @part.categories as |category|}}
      <Category @form={{@form}} @part={{@part}} @category={{category}} />
    {{/each}}
  </template>
}

class System extends Component<{ Args: { form: Form; system: JudgingSystem } }> {
  <template>
    {{#each @system.parts as |part|}}
      <Part @form={{@form}} @part={{part}} />
    {{/each}}
  </template>
}

export class RoutineTesterForm extends Component {
  Form = Form<Data, boolean>;

  data: Data = {};

  <template>
    <this.Form @data={{this.data}} as |f|>
      <System @form={{f}} @system={{judgingSystem}} />
    </this.Form>
  </template>
}
