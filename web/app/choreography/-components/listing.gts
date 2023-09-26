import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { PrinciplesResource } from '../resource';
import { Tag, TAGS } from '../../database/principles';
import styles from './listing.css';
import { eq } from 'ember-truth-helpers';
import { on } from '@ember/modifier';
import { htmlSafe } from '@ember/template';

import type { TOC } from '@ember/component/template-only';

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

export default class ChoreographyNotTodoList extends Component {
  @tracked tag?: Tag;

  principles = PrinciplesResource.from(this, () => ({
    tag: this.tag
  }));

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

    {{#each this.principles.principles as |principle|}}
      <details class={{styles.principle}}>
        <summary>
          {{principle.title}}
          <span>
            {{#each principle.tags as |tag|}}
              <TagUI @tag={{tag}} />
            {{/each}}
          </span>
        </summary>

        {{htmlSafe principle.contents}}
      </details>
    {{/each}}
  </template>
}
