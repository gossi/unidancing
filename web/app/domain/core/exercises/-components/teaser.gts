import { on } from '@ember/modifier';

import { or } from 'ember-truth-helpers';

import { Card } from '@hokulea/ember';

import { Icon } from '../../../supporting/ui';
import { asString } from '../../../supporting/utils';
import { buildSkillLink } from '../../skills';
import { buildExerciseLink } from '..';
import { asLocomotion, asPersonal } from '../-helpers';
import { FormatLocomotionIcon, FormatPersonalIcon } from './-formatters';
import styles from './teaser.css';

import type { Exercise } from '..';
import type { TOC } from '@ember/component/template-only';

export interface ExerciseTeaserSignature {
  Element: HTMLElement;
  Args: {
    exercise: Exercise;
  };
}

const ExerciseTeaser: TOC<ExerciseTeaserSignature> = <template>
  <Card class={{styles.card}}>
    <:header>
      <span>
        <Icon @icon="exercise" />

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
          <FormatLocomotionIcon @locomotion={{asLocomotion locomotion}}/>
        {{/each}}

        {{#each @exercise.personal as |personal|}}
          <FormatPersonalIcon @personal={{asPersonal personal}}/>
        {{/each}}
      </div>
    </:header>

    <:body>
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
    </:body>
  </Card>
</template>;

export { ExerciseTeaser };
