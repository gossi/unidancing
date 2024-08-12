import { htmlSafe } from '@ember/template';

import { element } from 'ember-element-helper';
import { eq, or } from 'ember-truth-helpers';

import type { TOC } from '@ember/component/template-only';

type TinaMarkdownContent = {
  type: string;
  // type = text
  text: string;
  // type = img | a
  url: string;
  // type = img
  caption: string;
  // type = code_block | html | html_inline
  value: string;

  // anyway
  children: TinaMarkdownContent[];
};

function elementFor(type: string) {
  switch (type) {
    case 'bold':
      return 'b';

    case 'italic':
      return 'i';

    case 'strikethrough':
      return 's';

    case 'underline':
      return 'u';

    // case 'h1':
    // case 'h2':
    // case 'h3':
    // case 'h4':
    // case 'h5':
    // case 'h6':
    // case 'p':
    // case 'blockquote':
    // case 'ol':
    // case 'ul':
    // case 'li':
    // case 'code':
    default:
      return type;
  }
}

function contentToNodes(
  content: TinaMarkdownContent | TinaMarkdownContent[]
): TinaMarkdownContent[] {
  return Array.isArray(content) ? content : content.children;
}

const TinaMarkdown: TOC<{
  Args: { content: TinaMarkdownContent | TinaMarkdownContent[] };
}> = <template>
  {{#if @content}}
    {{#each (contentToNodes @content) as |node|}}
      {{! error handling }}
      {{#if (eq node.type "invalid_markdown")}}
        <pre>{{node.value}}</pre>

        {{! handle text }}
      {{else if (eq node.type "text")}}
        {{node.text}}

        {{! handle special elements }}
      {{else if (eq node.type "break")}}
        <br />
      {{else if (eq node.type "hr")}}
        <hr />
      {{else if (eq node.type "img")}}
        <img src={{node.url}} alt={{node.caption}} />
      {{else if (eq node.type "a")}}
        <a href={{node.url}}>
          <TinaMarkdown @content={{node.children}} />
        </a>
      {{else if (eq node.type "code_block")}}
        <pre>
          <code>{{node.value}}</code>
        </pre>
      {{else if (or (eq node.type "html") (eq node.type "html_inline"))}}
        {{htmlSafe node.value}}

        {{! handle primitive elements }}
      {{else}}
        {{#let (elementFor node.type) as |elem|}}
          {{#if elem}}
            {{#let (element elem) as |E|}}
              <E><TinaMarkdown @content={{node.children}} /></E>
            {{/let}}
          {{/if}}
        {{/let}}
      {{/if}}
    {{/each}}
  {{/if}}
</template>;

export { TinaMarkdown };
