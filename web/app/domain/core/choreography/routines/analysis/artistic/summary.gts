import Component from '@glimmer/component';

import { t } from 'ember-intl';

import { Score } from '../../artistic/-components';
import { toIntlNameKey } from '../../artistic/-utils';
import { loadSystem, loadSystemDescriptor } from '../../systems/actions';

import type { ArtisticResults, CategoryResult, PartResult } from '../../artistic/domain-objects';

export class ArtisticSummary extends Component<{
  Args: { data: ArtisticResults };
}> {
  categoryIntlName = (part: PartResult, category: CategoryResult) => {
    return `artistic-${part.name}-${category.name}`;
  };

  get system() {
    return loadSystem(loadSystemDescriptor(this.args.data.name));
  }

  get score() {
    return (this.args.data.parts.find((p) => p.name === 'performance') as PartResult).score;
  }

  <template>
    <div class="summary">
      {{#each @data.parts as |part|}}
        <div data-parts>
          {{#each part.categories as |category|}}
            <div data-category>
              <p>{{t (toIntlNameKey (this.categoryIntlName part category))}}</p>
              <p>
                <Score @score={{category.score}} />
              </p>
            </div>
          {{/each}}
        </div>
      {{/each}}
      <div data-total>
        <span>Score:</span>
        <Score @score={{this.score}} />
      </div>
    </div>

    <style scoped>
      .summary {
        p {
          height: 2.5em;
          padding: 0.5rem 0.75rem;
          border-inline-end: 1px solid var(--shape-stroke-color);

          &:last-child {
            border-block-end: 1px solid var(--shape-stroke-color);
          }
        }

        [data-total] {
          padding: 0.5rem 0.75rem;
          border: 1px solid var(--shape-stroke-color);
          background: var(--surface-container1);
        }

        [data-parts] {
          display: grid;
          grid-template-columns: repeat(3, 1fr);
          border-block-start: 1px solid var(--shape-stroke-color);
          border-inline-start: 1px solid var(--shape-stroke-color);
        }

        [data-category] {
          display: grid;

          p:first-child {
            border-block-end: 1px solid var(--shape-stroke-color);
            background: var(--surface-container);
          }
        }
      }
    </style>
  </template>
}
