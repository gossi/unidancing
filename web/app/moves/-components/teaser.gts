import { Move } from '../../database/moves';
import { Link } from 'ember-link';
import { htmlSafe } from '@ember/template';
import { on } from '@ember/modifier';
import styles from './teaser.css';
import Icon from '../../components/icon';
import type { TOC } from '@ember/component/template-only';

export interface MoveTeaserSignature {
  Element: HTMLElement;
  Args: {
    move: Move;
    link: Link;
  };
}

const MoveTeaser: TOC<MoveTeaserSignature> = <template>
  <article>
    <header class={{styles.header}}>
      <span>
        <Icon @icon='move' />

        {{#let @link as |l|}}
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
    {{htmlSafe @move.excerpt}}
  </article>
</template>;

export default MoveTeaser;
