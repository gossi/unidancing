import type { TOC } from '@ember/component/template-only';

const Features: TOC<{
  Element: HTMLDivElement;
  Blocks: { default: [] };
}> = <template>
  <div class="features" ...attributes>
    {{yield}}
  </div>
  <style scoped>
    .features {
      --min: 25ch;
      --gap: 1rem;

      display: grid;
      grid-gap: var(--gap);
      grid-template-columns: repeat(auto-fit, minmax(min(100%, var(--min)), 1fr));

      h2 {
        --font-size: 20px;

        margin-bottom: revert;
      }
    }
  </style>
</template>;

export default Features;
