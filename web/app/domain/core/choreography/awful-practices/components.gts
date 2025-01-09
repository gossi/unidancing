import { TinaMarkdown } from '../../../supporting/tina';
import { asTag, type Awfulpractice, type Tag } from './domain';
import styles from './styles.css';

import type { TOC } from '@ember/component/template-only';

export const TagLabel: TOC<{
  Element: HTMLSpanElement;
  Args: {
    tag: Tag;
    selected?: boolean;
  };
}> = <template>
  <span class={{styles.tag}} data-tag={{@tag}} ...attributes>{{@tag}}</span>
</template>;

export const AwfulPracticeDetails: TOC<{ Args: { practice: Awfulpractice } }> = <template>
  <details class={{styles.principle}}>
    <summary>
      <span>
        {{@practice.title}}
        <span>
          {{#each @practice.tags as |tag|}}
            <TagLabel @tag={{asTag tag}} />
          {{/each}}
        </span>
      </span>
    </summary>

    <TinaMarkdown @content={{@practice.body}} />
  </details>
</template>;
