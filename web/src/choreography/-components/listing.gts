import Component from '@glimmer/component';
import { cached, tracked } from '@glimmer/tracking';

import { use } from 'ember-resources';
import Task from 'ember-tasks';

import { AwfulPracticeDetails, TagLabel } from '../awful-practices/components';
import { TAGS } from '../awful-practices/domain';
import { filterByTag, findAwfulPractices } from '../awful-practices/resources';

import type { Awfulpractice, Tag } from '../awful-practices/domain';

export default class ChoreographyNotTodoList extends Component {
  @tracked tag?: Tag;

  setFilter = (tag: Tag) => {
    return () => {
      this.tag = tag === this.tag ? undefined : tag;
    };
  };

  @cached
  get load() {
    const promise = use(this, findAwfulPractices()).current;

    return Task.promise(promise);
  }

  filter = (practices: Awfulpractice[]): Awfulpractice[] => {
    if (this.tag) {
      practices = filterByTag(practices, this.tag);
    }

    return practices;
  };

  <template>
    <p>
      Filter:
      {{#each TAGS as |tag|}}
        <TagLabel
          @tag={{tag}}
          @selected={{eq tag this.tag}}
          role="button"
          {{on "click" (this.setFilter tag)}}
        />
      {{/each}}
    </p>

    {{#let this.load as |r|}}
      {{#if r.resolved}}
        {{#let (this.filter r.value) as |principles|}}
          {{#each principles as |principle|}}
            <AwfulPracticeDetails @practice={{principle}} />
          {{/each}}
        {{/let}}
      {{/if}}
    {{/let}}
  </template>
}
