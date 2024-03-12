import { on } from '@ember/modifier';
import styles from './teaser.css';
import { formatPersonalIcon, formatLocomotionIcon, asPersonal, asLocomotion } from '../-helpers';
import { Icon } from '../../../supporting/ui';
import { buildExerciseLink } from '..';
import { or } from 'ember-truth-helpers';
import { buildSkillLink } from '../../skills';
import { asString } from '../../../supporting/utils';

import type { TOC } from '@ember/component/template-only';
import type { Exercise } from '..';

export interface ExerciseTeaserSignature {
  Element: HTMLElement;
  Args: {
    exercise: Exercise;
  };
}

const ExerciseTeaser: TOC<ExerciseTeaserSignature> = <template>
  <article class={{styles.card}}>
    <header class={{styles.header}}>
      <span>
        <Icon @icon='exercise' />

        {{#let (buildExerciseLink @exercise._sys.filename) as |l|}}
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
          {{formatLocomotionIcon (asLocomotion locomotion)}}
        {{/each}}

        {{#each @exercise.personal as |personal|}}
          {{formatPersonalIcon (asPersonal personal)}}
        {{/each}}
      </div>
    </header>

    <div class={{styles.content}}>
      <div>
        {{@exercise.excerpt}}
      </div>
      <ul>
        {{#if (or @exercise.art @exercise.technique @exercise.skills)}}

          {{#if @exercise.art}}
            <li><Icon @icon="art"/> {{@exercise.art.title}}</li>
          {{/if}}

          {{#if @exercise.technique}}
            <li><Icon @icon="technique"/> {{@exercise.technique.title}}</li>
          {{/if}}

          {{#each @exercise.skills as |skill|}}
            <li>
              {{#let (buildSkillLink (asString skill.data._sys.filename)) as |l|}}
                <Icon @icon='skill' />
                <a href={{l.url}} {{on 'click' l.transitionTo}}>
                  {{skill.data.title}}
                </a>
              {{/let}}
            </li>
          {{/each}}
        {{/if}}
      </ul>
    </div>
  </article>
</template>;

export { ExerciseTeaser };
