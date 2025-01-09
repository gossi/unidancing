import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { cached } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { service } from '@ember/service';

import { use } from 'ember-resources';
import Task from 'ember-tasks';
import { eq } from 'ember-truth-helpers';

import { AwfulPracticeDetails, TagLabel } from '../awful-practices/components';
import { TAGS } from '../awful-practices/domain';
import { filterByTag, findAwfulPractices } from '../awful-practices/resources';

import type { Awfulpractice, Tag } from '../awful-practices/domain';
import type FastbootService from 'ember-cli-fastboot/services/fastboot';

export default class ChoreographyNotTodoList extends Component {
  @service declare fastboot: FastbootService;

  @tracked tag?: Tag;

  setFilter = (tag: Tag) => {
    return () => {
      if (tag === this.tag) {
        this.tag = undefined;
      } else {
        this.tag = tag;
      }
    };
  };

  @cached
  get load() {
    const promise = use(this, findAwfulPractices()).current;

    if (this.fastboot.isFastBoot) {
      this.fastboot.deferRendering(promise);
    }

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
