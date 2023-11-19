import styles from './content.css';
import { element } from 'ember-element-helper';

import type { TOC } from '@ember/component/template-only';
import type { ComponentLike } from '@glint/template';

export interface CardSignature {
  Element: HTMLDivElement;
  Args: {
    element?: ComponentLike<{ Element: HTMLElement }>;
  };
  Blocks: {
    default: [];
  };
}

const Card: TOC<CardSignature> = <template>
  {{#let (if @element @element (element 'div')) as |Element|}}
    {{! @glint-expect-error https://github.com/typed-ember/glint/issues/610 }}
    <Element class={{styles.card}} ...attributes>
      {{yield}}
    </Element>
  {{/let}}
</template>;

export default Card;
