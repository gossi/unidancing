import Component from '@glimmer/component';

import { t } from 'ember-intl';

import { loadSystem, loadSystemDescriptor } from '../systems/actions';
import { Score } from './-components';
import { toIntlNameKey } from './-utils';
import styles from './artistic.css';

import type { ArtisticResults, CategoryResult, PartResult } from './domain-objects';

export class ArtisticSummary extends Component<{
  Args: { data: ArtisticResults };
}> {
  get system() {
    return loadSystem(loadSystemDescriptor(this.args.data.name));
  }

  get score() {
    return (this.args.data.parts.find((p) => p.name === 'performance') as PartResult).score;
  }

  categoryIntlName = (part: PartResult, category: CategoryResult) => {
    return `artistic-${part.name}-${category.name}`;
  };

  <template>
    <div class={{styles.summary}}>
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
        <span class={{styles.score}} data-score="label">Score:</span>
        <Score @score={{this.score}} />
      </div>
    </div>
  </template>
}
