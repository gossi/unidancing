import type { TOC } from '@ember/component/template-only';
import styles from './features.css';
import { hash } from '@ember/helper';

const Features: TOC<{
  Element: HTMLDivElement;
  Blocks: { default: [{ list: string }] };
}> = <template>
  <div class={{styles.features}} ...attributes>
    {{yield (hash list=styles.list)}}
  </div>
</template>;

export default Features;
