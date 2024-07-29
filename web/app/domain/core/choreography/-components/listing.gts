import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { cached } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { service } from '@ember/service';

import { use } from 'ember-resources';
import Task from 'ember-tasks';
import { eq } from 'ember-truth-helpers';

import { TinaMarkdown } from '../../../supporting/tina';
import { TAGS } from '..';
import { findAwfulPractices } from '../-resource';
import styles from './listing.css';

import type { Tag} from '..';
import type { Maybe } from '@/tina/types';
import type { TOC } from '@ember/component/template-only';
import type FastbootService from 'ember-cli-fastboot/services/fastboot';

const TagUI: TOC<{
  Element: HTMLSpanElement;
  Args: {
    tag: Tag;
    selected?: boolean;
  };
}> = <template>
  <span
    class={{styles.tag}}
    data-tag={{@tag}} ...attributes
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
              <span>
                {{principle.title}}
                <span>
                  {{#each principle.tags as |tag|}}
                    <TagUI @tag={{asTag tag}} />
                  {{/each}}
                </span>
              </span>
            </summary>

            <TinaMarkdown @content={{principle.body}}/>
          </details>
        {{/each}}
      {{/if}}
    {{/let}}
  </template>
}
