import { uniqueId } from '@ember/helper';
import { on } from '@ember/modifier';

import { or } from 'ember-truth-helpers';

import { Page } from '@hokulea/ember';

import { TinaMarkdown } from '../../../supporting/tina';
import { Icon, Tag, VideoPlayer } from '../../../supporting/ui';
import { asString } from '../../../supporting/utils';
import { buildSkillLink } from '../../skills';
import { buildExerciseLink } from '../-resource';
import {
  asDifficulty,
  asLocomotion,
  asMediaCollection,
  asPersonal,
  type Exercise
} from '../domain-objects';
import { FormatLocomotion, FormatPersonal } from './-formatters';
import styles from './details.css';
import Difficulty from './difficulty';
import { Instruction } from './instruction';
import { Media } from './media';

import type { TOC } from '@ember/component/template-only';

export interface ExerciseDetailsSignature {
  Args: {
    exercise: Exercise;
  };
}

const ExerciseDetails: TOC<ExerciseDetailsSignature> = <template>
  <Page>
    <:title><Icon @icon="exercise" /> {{@exercise.title}}</:title>
    <:description>
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
    </:description>

    <:content>
      <div class={{styles.layout}}>
        <section class={{styles.main}}>
          {{#if @exercise.media}}
            <header class={{styles.header}}>
              <Media @media={{asMediaCollection @exercise.media}} />
            </header>
          {{/if}}

          {{#if @exercise.video}}
            <VideoPlayer @url={{@exercise.video}} class={{styles.player}} />
          {{/if}}

          <TinaMarkdown @content={{@exercise.body}} />

          {{#if @exercise.instruction}}
            <h2>Verlauf</h2>

            <Instruction @instructions={{@exercise.instruction}} />
          {{/if}}
        </section>

        {{#if (or @exercise.links @exercise.exercises @exercise.skills @exercise.material)}}
          <aside>
            <section>
              {{#if (or @exercise.links @exercise.exercises)}}
                {{#let (uniqueId) as |exercisesId|}}
                  <nav aria-labelledby={{exercisesId}}>
                    <span id={{exercisesId}}>Siehe auch</span>:

                    <ul>
                      {{#each @exercise.exercises as |ex|}}
                        <li>
                          {{#let (buildExerciseLink (asString ex.data._sys.filename)) as |l|}}
                            <a href={{l.url}} {{on "click" l.transitionTo}}>
                              <Icon @icon="exercise" />
                              {{ex.data.title}}
                            </a>
                          {{/let}}
                        </li>
                      {{/each}}

                      {{#each @exercise.links as |see|}}
                        <li>
                          <a href={{see.url}} target="_blank" rel="noopener noreferrer">
                            <Icon @icon="link" />
                            {{if see.label see.label see.url}}
                          </a>
                        </li>
                      {{/each}}
                    </ul>
                  </nav>
                {{/let}}
              {{/if}}

              {{#if @exercise.skills}}
                {{#let (uniqueId) as |skillsId|}}
                  <nav aria-labelledby={{skillsId}}>
                    <span id={{skillsId}}>Fertigkeiten</span>:

                    <ul>
                      {{#each @exercise.skills as |skill|}}
                        <li>
                          {{#let (buildSkillLink (asString skill.data._sys.filename)) as |l|}}
                            <a href={{l.url}} {{on "click" l.transitionTo}}>
                              <Icon @icon="skill" />
                              {{skill.data.title}}
                            </a>
                          {{/let}}
                        </li>
                      {{/each}}
                    </ul>
                  </nav>
                {{/let}}
              {{/if}}

              {{#if @exercise.material}}
                <ul>
                  Das brauchst du:

                  {{#each @exercise.material as |material|}}
                    <li>{{material}}</li>
                  {{/each}}
                </ul>
              {{/if}}
            </section>
          </aside>
        {{/if}}
      </div>
    </:content>
  </Page>
</template>;

export { ExerciseDetails };
