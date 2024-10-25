import styles from './note.css';

import type { TOC } from '@ember/component/template-only';

interface NoteSignature {
  Element: HTMLElement;
  Args: {
    indicator?: 'info' | 'success' | 'warning' | 'error';
    importance?: 'supreme' | 'subtle' | 'plain';
  };
  Blocks: {
    default: [];
  };
}

const Note: TOC<NoteSignature> = <template>
  <aside
    role="note"
    class={{styles.alert}}
    data-indicator={{if @indicator @indicator "info"}}
    data-importance={{if @importance @importance "subtle"}}
    ...attributes
  >{{yield}}</aside>
</template>;

export default Note;
