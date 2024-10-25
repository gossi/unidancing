import styles from './features.css';

import type { TOC } from '@ember/component/template-only';

const Features: TOC<{
  Element: HTMLDivElement;
  Blocks: { default: [] };
}> = <template>
  <div class={{styles.features}} ...attributes>
    {{yield}}
  </div>
</template>;

export default Features;
