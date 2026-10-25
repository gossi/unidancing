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

const Section: TOC<SectionSignature> = <template>
  <section class="section" data-test-section ...attributes>
    {{#if (or (has-block "header") @title)}}
      {{#let (element "h2") as |Headline|}}
        <header data-test-section="header" part="header">
          {{#if @title}}
            <Headline class="title">{{@title}}</Headline>
          {{else if (has-block "header")}}
            {{! @glint-ignore Headline type shenanigans }}
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

  <style scoped>
    .section {
      header {
        align-items: center;
        display: flex;
        justify-content: space-between;
        position: relative;
      }
    }

    .title {
      color: var(--pico-typography-main);
      font-size: 18px;
      font-weight: 500;
      line-height: 26px;
      margin: 0;
    }
  </style>
</template>;

export default Section;
