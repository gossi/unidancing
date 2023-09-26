import { Exercise } from '../../database/exercises';
import { Link } from 'ember-link';
import { htmlSafe } from '@ember/template';
import { on } from '@ember/modifier';
import styles from './teaser.css';
import { formatPersonalIcon } from '../../helpers/format-personal';
import { formatLocomotionIcon } from '../../helpers/format-locomotion';
import Icon from '../../components/icon';

import type { TOC } from '@ember/component/template-only';

export interface ExerciseTeaserSignature {
  Element: HTMLElement;
  Args: {
    exercise: Exercise;
    link: Link;
  };
}

const ExerciseTeaser: TOC<ExerciseTeaserSignature> = <template>
  <article>
    <header class={{styles.header}}>
      <span>
        <Icon @icon='exercise' />

        {{#let @link as |l|}}
          <a href={{l.url}} {{on 'click' l.transitionTo}}>
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
</template>;

export default ExerciseTeaser;
