import { formatNumber } from '@unidancing/app/domain/supporting/utils';

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
  <details ...attributes class="explainer">
    <summary>
      {{yield to="title"}}
    </summary>

    {{yield to="content"}}
  </details>

  <style scoped>
    .explainer {
      font-size: var(--ls-1);

      summary {
        font-size: var(--s0);

        span {
          float: right;
        }
      }

      &[open] {
        summary {
          margin-block-end: var(--spacing-primitive-2);
        }
      }
    }
  </style>
</template>;

interface ExplainerTableSignature {
  Args: {
    groups: AttractivityGroup[];
  };
}

export const ExplainerTable: TOC<ExplainerTableSignature> = <template>
  <table class="explainerTable">
    <tbody>
      {{#each @groups as |group|}}
        <tr>
          <td>{{group.content}}</td>
          <td data-attractivity={{group.attractivity}} class="digits">
            {{formatNumber group.value (hash signDisplay="exceptZero")}}</td>
        </tr>
      {{/each}}
    </tbody>
  </table>

  <style scoped>
    .explainerTable {
      border-collapse: collapse;
      width: 100%;

      tr {
        border-block-end: 1px solid var(--shape-stroke-color);

        &:last-child {
          border-block-end: none;
        }
      }

      td {
        padding: 0.5rem 0.75rem;

        &:last-child {
          text-align: right;
        }
      }

      [data-attractivity="attractor"] {
        color: var(--indicator-success-plain-text);
      }

      [data-attractivity="detractor"] {
        color: var(--indicator-error-plain-text);
      }
    }
  </style>
</template>;
