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
  {{#let (if @element @element (element "div")) as |Element|}}
    {{! @glint-expect-error https://github.com/typed-ember/glint/issues/610 }}
    <Element class="card" ...attributes>
      {{yield}}
    </Element>
  {{/let}}

  <style scoped>
    .card {
      background: var(--pico-card-background-color);
      border-radius: var(--pico-border-radius);
      box-shadow: var(--pico-card-box-shadow);
      padding: var(--pico-block-spacing-vertical) var(--pico-block-spacing-horizontal);
    }
  </style>
</template>;

export default Card;
