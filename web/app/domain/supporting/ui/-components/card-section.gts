// import styles from '@hokulea/core/content.css';

import Section from './section';

import type { SectionSignature } from './section';
import type { TOC } from '@ember/component/template-only';

const CardSection: TOC<SectionSignature> = <template>
  <Section @title={{@title}}  ...attributes>
    <:header as |Headline|>
      {{#if (has-block 'header')}}
        {{yield Headline to='header'}}
      {{/if}}
    </:header>

    <:body>
      {{#if (has-block 'body')}}
        {{yield to='body'}}
      {{else if (has-block)}}
        {{yield}}
      {{/if}}
    </:body>
  </Section>
</template>;

export default CardSection;
