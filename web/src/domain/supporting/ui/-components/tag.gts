import type { TOC } from '@ember/component/template-only';

interface TagSignature {
  Element: HTMLElement;
  Blocks: {
    default: [];
  };
}

const Tag: TOC<TagSignature> = <template>
  <span class="tag" ...attributes>{{yield}}</span>

  <style scoped>
    .tag {
      padding: 0.25em;

      font-size: 80%;
      font-weight: 500;
      color: var(--typography-code-text);
      white-space: nowrap;

      background-color: hsl(from var(--typography-code-background) h s calc(l - 3));
      border-radius: 4px;
    }
  </style>
</template>;

export default Tag;
