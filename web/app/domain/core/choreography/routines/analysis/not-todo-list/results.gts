import Component from '@glimmer/component';
import { cached } from '@glimmer/tracking';
import { service } from '@ember/service';

import { use } from 'ember-resources';
import Task from 'ember-tasks';

import { AwfulPracticeDetails } from '../../../awful-practices/components';
import { findAwfulPractices } from '../../../awful-practices/resources';

import type { Awfulpractice } from '../../../awful-practices/domain';
import type { NotTodoList } from './domain';
import type FastbootService from 'ember-cli-fastboot/services/fastboot';

interface NotTodoListResultsSignature {
  Args: {
    data: NotTodoList;
  };
}

export class NotTodoListResults extends Component<NotTodoListResultsSignature> {
  @service declare fastboot: FastbootService;

  @cached
  get load() {
    const promise = use(this, findAwfulPractices()).current;

    if (this.fastboot.isFastBoot) {
      this.fastboot.deferRendering(promise);
    }

    return Task.promise(promise);
  }

  filter = (practices: Awfulpractice[]): Awfulpractice[] => {
    return practices.filter((p) => this.args.data.includes(p._sys.filename));
  };

  <template>
    {{#let this.load as |r|}}
      {{#if r.resolved}}
        {{#each (this.filter r.value) as |practice|}}
          <AwfulPracticeDetails @practice={{practice}} />
        {{/each}}
      {{/if}}
    {{/let}}
  </template>
}
