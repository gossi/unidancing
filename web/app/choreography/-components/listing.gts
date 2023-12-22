import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { Tag, TAGS } from '..';
import styles from './listing.css';
import { eq } from 'ember-truth-helpers';
import { on } from '@ember/modifier';
import { load } from 'ember-async-data';
import { findAwfulPractices } from '../resource';
import { TinaMarkdown } from '../../components';

import type { TOC } from '@ember/component/template-only';
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

    {{#let (load (findAwfulPractices this.tag)) as |r|}}
      {{#if r.isResolved}}
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
