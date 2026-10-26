import { TinaMarkdown } from '../../../supporting/tina';
import { asTag, type Awfulpractice, type Tag } from './domain';

import type { TOC } from '@ember/component/template-only';

export const TagLabel: TOC<{
  Element: HTMLSpanElement;
  Args: {
    tag: Tag;
    selected?: boolean;
  };
}> = <template>
  <span class="tag" data-tag={{@tag}} ...attributes>{{@tag}}</span>

  <style scoped>
    .tag {
      padding: 0.1em 0.3em;
      border-radius: 4px;

      font-size: 80%;
      font-weight: 500;
      color: var(--typography-main);

      background-color: #f5f5f5;

      &:not([aria-selected]) {
        border: none;
      }

      &[data-tag="choreography"] {
        --color: aqua;

        background-color: var(--color);

        /* color: color-contrast(var(--color) vs var(--typography-main), var(--typography-inverse)); */
      }

      &[data-tag="artistry"] {
        --color: coral;

        background-color: var(--color);

        /* color: color-contrast(var(--color) vs var(--typography-main), var(--typography-inverse)); */
      }

      &[data-tag="tricks"] {
        --color: bisque;

        background-color: var(--color);

        /* color: color-contrast(var(--color) vs var(--typography-main), var(--typography-inverse)); */
      }

      &[data-tag="flow"] {
        --color: yellow;

        background-color: var(--color);

        /* color: color-contrast(var(--color) vs var(--typography-main), var(--typography-inverse)); */
      }

      &[data-tag="posture"] {
        --color: gold;

        background-color: var(--color);

        /* color: color-contrast(var(--color) vs var(--typography-main), var(--typography-inverse)); */
      }

      &[data-tag="competition"] {
        --color: paleturquoise;

        background-color: var(--color);

        /* color: color-contrast(var(--color) vs var(--typography-main), var(--typography-inverse)); */
      }

      &[data-tag="misc"] {
        --color: greenyellow;

        background-color: var(--color);

        /* color: color-contrast(var(--color) vs var(--typography-main), var(--typography-inverse)); */
      }

      @media (prefers-color-scheme: dark) {
        color: var(--typography-inverse);
      }
    }
  </style>
</template>;

export const AwfulPracticeDetails: TOC<{ Args: { practice: Awfulpractice } }> = <template>
  <details class="principle">
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

  <style scoped>
    .principle {
      summary > span {
        display: inline-flex;
        flex-wrap: wrap;
        width: calc(100% - 1.5em);

        & > span {
          margin-inline-start: auto;
        }
      }

      details&[open] > :is(summary, summary:not(:focus), summary:focus:not([role="button"])) {
        margin-bottom: 1em;
        font-weight: 500;
        color: unset;
      }

      & > *:not(summary) {
        font-size: 80%;
      }
    }
  </style>
</template>;
