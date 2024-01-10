import { on } from '@ember/modifier';
import styles from './teaser.css';
import { Icon } from '@unidancing/ui';
import { buildMoveLink } from '../-resource';

import type { Move } from '..';
import type { TOC } from '@ember/component/template-only';

export interface MoveTeaserSignature {
  Args: {
    move: Move;
  };
}

const MoveTeaser: TOC<MoveTeaserSignature> = <template>
  <article>
    <header class={{styles.header}}>
      <span>
        <Icon @icon='move' />

        {{#let (buildMoveLink @move._sys.filename) as |l|}}
          <a href={{l.url}} {{on 'click' l.transitionTo}}>
            {{@move.title}}
          </a>
        {{/let}}
      </span>
      <div>
        {{#each @move.tags as |tag|}}
          <code>{{tag}}</code>
        {{/each}}
      </div>
    </header>

    {{@move.excerpt}}
  </article>
</template>;

export { MoveTeaser };
