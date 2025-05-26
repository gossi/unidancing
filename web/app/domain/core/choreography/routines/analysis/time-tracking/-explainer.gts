import { hash } from '@ember/helper';

import { formatNumber } from '@unidancing/app/domain/supporting/utils';

import styles from './evaluation.css';

import type { AttractivityGroup } from './domain';
import type { TOC } from '@ember/component/template-only';

interface ExplainerSignature {
  Element: HTMLDetailsElement;
  Blocks: {
    title: [];
    content: [];
  };
}

export const Explainer: TOC<ExplainerSignature> = <template>
  <details ...attributes class={{styles.explainer}}>
    <summary>
      {{yield to="title"}}
    </summary>

    {{yield to="content"}}
  </details>
</template>;

interface ExplainerTableSignature {
  Args: {
    groups: AttractivityGroup[];
  };
}

export const ExplainerTable: TOC<ExplainerTableSignature> = <template>
  <table class={{styles.explainerTable}}>
    {{#each @groups as |group|}}
      <tr>
        <td>{{group.content}}</td>
        <td data-attractivity={{group.attractivity}} class="digits">
          {{formatNumber group.value (hash signDisplay="exceptZero")}}</td>
      </tr>
    {{/each}}
  </table>
</template>;
