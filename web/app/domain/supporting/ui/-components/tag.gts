import styles from './tag.css';

import type { TOC } from '@ember/component/template-only';

interface TagSignature {
  Element: HTMLElement;
  Blocks: {
    default: [];
  };
}

const Tag: TOC<TagSignature> = <template>
  <span class={{styles.tag}} ...attributes>{{yield}}</span>
</template>;

export default Tag;
