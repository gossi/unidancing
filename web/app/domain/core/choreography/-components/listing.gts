import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { Tag, TAGS } from '..';
import styles from './listing.css';
import { eq } from 'ember-truth-helpers';
import { on } from '@ember/modifier';
import { use } from 'ember-resources';
import { findAwfulPractices } from '../-resource';
import { TinaMarkdown } from '@unidancing/tina';
import { service } from '@ember/service';
import { cached } from '@glimmer/tracking';
import Task from 'ember-tasks';

import type { TOC } from '@ember/component/template-only';
import type FastbootService from 'ember-cli-fastboot/services/fastboot';
import type { Maybe } from '@/tina/types';

const TagUI: TOC<{
  Element: HTMLSpanElement;
  Args: {
    tag: Tag;
    selected?: boolean;
  };
}> = <template>
  <span
    class={{styles.tag}}
    data-tag={{@tag}}
    aria-selected={{@selected}}
    ...attributes
  >{{@tag}}</span>
</template>;

const asTag = (tag: Maybe<string>): Tag => {
  return tag as Tag;
}

export default class ChoreographyNotTodoList extends Component {
  @service declare fastboot: FastbootService;

  @tracked tag?: Tag;

  filter = (tag: Tag) => {
    return () => {
      if (tag === this.tag) {
        this.tag = undefined;
      } else {
        this.tag = tag;
      }
    };
  }

  @cached
  get load() {
    const promise = use(this, findAwfulPractices(this.tag)).current;

    if (this.fastboot.isFastBoot) {
      this.fastboot.deferRendering(promise);
    }

    return Task.promise(promise);
  }

  <template>
    <p>
      Filter:
      {{#each TAGS as |tag|}}
        <TagUI
          @tag={{tag}}
          @selected={{eq tag this.tag}}
          role='button'
          {{on 'click' (this.filter tag)}}
        />
      {{/each}}
    </p>

    {{#let this.load as |r|}}
      {{#if r.resolved}}
        {{#each r.value as |principle|}}
          <details class={{styles.principle}}>
            <summary>
              {{principle.title}}
              <span>
                {{#each principle.tags as |tag|}}
                  <TagUI @tag={{asTag tag}} />
                {{/each}}
              </span>
            </summary>

            <TinaMarkdown @content={{principle.body}}/>
          </details>
        {{/each}}
      {{/if}}
    {{/let}}
  </template>
}
