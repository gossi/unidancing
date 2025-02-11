import { element } from 'ember-element-helper';

import styles from './content.css';

import type { TOC } from '@ember/component/template-only';
import type { ComponentLike } from '@glint/template';

export interface SectionSignature {
  Element: HTMLElement;
  Args: {
    title?: string;
  };
  Blocks: {
    default: [];
    body: [];
    header: [Headline: ComponentLike<{ Element: HTMLHeadingElement; Blocks: { default: [] } }>];
  };
}

const or = (a: unknown, b: unknown) => a || b;

const Section: TOC<SectionSignature> = <template>
  <section class="{{styles.section}}" data-test-section ...attributes>
    {{#if (or (has-block "header") @title)}}
      {{#let (element "h2") as |Headline|}}
        <header data-test-section="header" part="header">
          {{#if @title}}
            <Headline class={{styles.title}}>{{@title}}</Headline>
          {{else if (has-block "header")}}
            {{!@glint-ignore Headline type shenanigans}}
            {{yield Headline to="header"}}
          {{/if}}
        </header>
      {{/let}}
    {{/if}}

    {{#if (has-block "body")}}
      {{yield to="body"}}
    {{else if (has-block)}}
      {{yield}}
    {{/if}}
  </section>
</template>;

export default Section;
