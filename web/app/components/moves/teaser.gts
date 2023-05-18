import Component from '@glimmer/component';
import { Move } from '../../database/moves';
import {Link} from 'ember-link';
import { htmlSafe } from '@ember/template';
import { on } from '@ember/modifier';
import styles from './teaser.css';
import Icon from '../icon';

export interface MoveTeaserSignature {
  Element: HTMLArticleElement;
  Args: {
    move: Move;
    link: Link;
  }
}

export default class MoveTeaserComponent extends Component<MoveTeaserSignature> {
  <template>
    <article>
      <header class={{styles.header}}>
        <span>
          <Icon @icon="move"/>

          {{#let @link as |l|}}
            <a href={{l.url}} {{on "click" l.transitionTo}}>
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
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    'Moves::Teaser': typeof MoveTeaserComponent;
  }
}
