import Component from '@glimmer/component';
import { cached } from '@glimmer/tracking';

import { use } from 'ember-resources';
import Task from 'ember-tasks';

import { findAwfulPractices } from '../../../awful-practices/resources';

import type { NotTodoListFormData } from './domain';
import type { FormBuilder } from '@hokulea/ember';

interface NotTodoListFormSignature {
  Args: {
    form: FormBuilder<NotTodoListFormData>;
  };
}

export class NotTodeListForm extends Component<NotTodoListFormSignature> {
  @cached
  get load() {
    const promise = use(this, findAwfulPractices()).current;

    return Task.promise(promise);
  }

  <template>
    {{#let @form as |f|}}
      {{#let this.load as |r|}}
        {{#if r.resolved}}
          <f.MultipleChoice @name="not-todo-list" @label="" as |c|>
            {{#each r.value as |practice|}}
              <c.Option @value={{practice._sys.filename}} @label={{practice.title}} />
            {{/each}}
          </f.MultipleChoice>
        {{/if}}
      {{/let}}
    {{/let}}
  </template>
}
