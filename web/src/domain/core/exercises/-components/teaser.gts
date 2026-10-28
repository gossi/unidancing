import { Card } from '@hokulea/ember';

import { Icon, Tag } from '../../../supporting/ui';
import { asString } from '../../../supporting/utils';
import { buildArtLink } from '../../arts';
import { buildSkillLink } from '../../skills';
import { buildExerciseLink } from '..';
import { asDifficulty, asLocomotion, asPersonal } from '../domain-objects';
import { FormatLocomotion, FormatPersonal } from './-formatters';
import Difficulty from './difficulty';

import type { Exercise } from '..';
import type { TOC } from '@ember/component/template-only';

export interface ExerciseTeaserSignature {
  Element: HTMLElement;
  Args: {
    exercise: Exercise;
  };
}

const ExerciseTeaser: TOC<ExerciseTeaserSignature> = <template>
  <Card class="card">
    <:header>
      <span>
        {{#let (buildExerciseLink @exercise._sys.filename) as |l|}}
          <a href={{l.url}} {{on "click" l.transitionTo}}>
            {{@exercise.title}}
          </a>
        {{/let}}
      </span>
      <div>
        <Difficulty @difficulty={{asDifficulty @exercise.difficulty}} />

        {{#each @exercise.personal as |personal|}}
          <Tag><FormatPersonal @personal={{asPersonal personal}} /></Tag>
        {{/each}}

        {{#each @exercise.locomotion as |locomotion|}}
          <Tag><FormatLocomotion @locomotion={{asLocomotion locomotion}} /></Tag>
        {{/each}}

        {{#each @exercise.tags as |tag|}}
          <Tag>#{{tag}}</Tag>
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
            <li>
              {{#let (buildArtLink (asString @exercise.art._sys.filename)) as |l|}}
                <a href={{l.url}} {{on "click" l.transitionTo}}>
                  <Icon @icon="art" />
                  {{@exercise.art.title}}
                </a>
              {{/let}}
            </li>
          {{/if}}

          {{#if @exercise.technique}}
            <li><Icon @icon="technique" /> {{@exercise.technique.title}}</li>
          {{/if}}

          {{#each @exercise.skills as |skill|}}
            <li>
              {{#let (buildSkillLink (asString skill.data._sys.filename)) as |l|}}
                <Icon @icon="skill" />
                <a href={{l.url}} {{on "click" l.transitionTo}}>
                  {{skill.data.title}}
                </a>
              {{/let}}
            </li>
          {{/each}}
        {{/if}}
      </ul>
    </:body>
  </Card>
  <style scoped>
    .card {
      display: flex;
      flex-direction: column;

      :global([part="header"]) {
        display: grid;
        gap: var(--spacing-primitive-4);

        div {
          display: flex;
          flex-wrap: wrap;
          gap: var(--spacing-primitive-4);
        }
      }

      :global([part="body"]) {
        display: flex;
        flex-direction: column;
        flex-grow: 1;
        gap: 0.75em;
        justify-content: space-between;

        ul {
          display: flex;
          flex-flow: row wrap;
          gap: 0.5em;
          justify-content: flex-end;

          margin: 0;
          padding: 0;

          font-size: 80%;
        }

        li {
          text-wrap: nowrap;
          list-style-type: none;
        }
      }
    }
  </style>
</template>;

export { ExerciseTeaser };
