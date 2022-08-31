import Component from '@glimmer/component';
import {Exercise, Personal} from '../../exercises/entries';
import {Link} from 'ember-link';
import { htmlSafe } from '@ember/template';
import { on } from '@ember/modifier';
import styles from './teaser.css';
import {formatPersonalIcon} from '../../helpers/format-personal';
import {formatLocomotionIcon} from '../../helpers/format-locomotion';

export interface ExerciseTeaserSignature {
  Element: HTMLArticleElement;
  Args: {
    exercise: Exercise;
    link: Link;
  }
}

export default class ExerciseTeaserComponent extends Component<ExerciseTeaserSignature> {
  <template>
    <article>
      <header class={{styles.header}}>
        <span>
          💃
        {{#let @link as |l|}}
          <a href={{l.url}} {{on "click" l.transitionTo}}>
            {{@exercise.title}}
          </a>
        {{/let}}
        </span>
        <div>
          {{#each @exercise.tags as |tag|}}
            <code>{{tag}}</code>
          {{/each}}

          {{#each @exercise.locomotion as |locomotion|}}
            {{formatLocomotionIcon locomotion}}
          {{/each}}

          {{#each @exercise.personal as |personal|}}
            {{formatPersonalIcon personal}}
          {{/each}}
        </div>
      </header>
      {{htmlSafe @exercise.excerpt}}
    </article>
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    'Exercises::Teaser': typeof ExerciseTeaserComponent;
  }
}
