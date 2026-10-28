import { uniqueId } from '@ember/helper';

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
  type Exercise,
  isMaterial
} from '../domain-objects';
import { FormatLocomotion, FormatPersonal } from './-formatters';
import Difficulty from './difficulty';
import { Instruction } from './instruction';
import { Media } from './media';

import type { ExerciseMedia, Maybe } from '@/tina/types';
import type { TOC } from '@ember/component/template-only';

function hasMaterial(media: Maybe<Maybe<ExerciseMedia>[]> | undefined) {
  // @ts-expect-error some tina types, huh?
  return media?.some((material: ExerciseMedia) => isMaterial(material));
}

function filterMaterial(media: Maybe<Maybe<ExerciseMedia>[]> | undefined) {
  // @ts-expect-error some tina types, huh?
  return (media ?? []).filter((material: ExerciseMedia) => isMaterial(material)) as ExerciseMedia[];
}

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
      <div class="layout">
        <section class="main">
          {{#if @exercise.media}}
            <header class="header">
              <Media @media={{asMediaCollection @exercise.media}} />
            </header>
          {{/if}}

          {{#if @exercise.video}}
            <VideoPlayer @url={{@exercise.video}} class="player" />
          {{/if}}

          <TinaMarkdown @content={{@exercise.body}} />

          {{#if @exercise.instruction}}
            <h2>Verlauf</h2>

            <Instruction @instructions={{@exercise.instruction}} />
          {{/if}}
        </section>

        {{#if
          (or @exercise.links @exercise.exercises @exercise.skills (hasMaterial @exercise.media))
        }}
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

              {{#if (hasMaterial @exercise.media)}}
                <ul>
                  Das brauchst du:

                  <Media @media={{filterMaterial @exercise.media}} />
                </ul>
              {{/if}}
            </section>
          </aside>
        {{/if}}
      </div>
    </:content>
  </Page>
  <style scoped>
    .header {
      margin-bottom: var(--typography-spacing-vertical);
    }

    .tagline {
      padding-inline-start: 2.5em;
    }

    .layout {
      display: flex;
      flex-wrap: wrap;
      gap: 2rem;

      iframe {
        margin-bottom: var(--block-spacing-vertical);
      }

      .main {
        display: flex;
        flex-direction: column;
        gap: var(--spacing-primitive0);
      }

      aside {
        & > section {
          padding: 1rem;
          background: var(--card-background-color);
          border-radius: var(--border-radius);
          box-shadow: var(--card-box-shadow);
        }

        li a {
          padding-left: 1.7em;
          text-indent: -1.2em;
        }
      }
    }

    .layout > :last-child {
      flex-basis: 30%;
      flex-grow: 1;
    }

    .layout > :first-child {
      flex-basis: 0;
      flex-grow: 999;
      min-inline-size: 65%;
    }

    .video {
      width: 80vw;
    }

    .curriculum {
      container-type: inline-size;

      & > div {
        display: grid;
        grid-template-columns: repeat(4, auto);

        & > div {
          display: grid;
          grid-column: span 4;
          grid-template-columns: subgrid;

          border-block-start: 1px solid var(--shape-stroke-color);
          border-inline-start: 1px solid var(--shape-stroke-color);

          & > * {
            padding: 0.5rem 0.75rem;
            border-inline-end: 1px solid var(--shape-stroke-color);

            &:first-child {
              border-block-end: 1px solid var(--shape-stroke-color);
            }
          }

          &:last-child {
            border-block-end: 1px solid var(--shape-stroke-color);
          }
        }

        [data-header] {
          background: var(--surface-container1);
          border-block-end: 1px solid var(--shape-stroke-color);
        }

        [data-title] {
          grid-column: span 4;
          background: var(--surface-container);

          details {
            &[open] summary {
              margin-block-end: var(--spacing-primitive-2);
            }

            :not(summary) {
              color: var(--typography-muted);
            }
          }
        }

        [data-instruction] {
          & > * + * {
            margin-block-start: 1em;
          }
        }

        @container (inline-size < 40em) {
          grid-template-columns: auto;
          gap: var(--spacing-container0);

          & > div {
            grid-column: auto;
            grid-template-areas:
              "title title"
              "duration method"
              "instruction instruction"
              "media media";
            grid-template-columns: 1fr 1fr;
            border-block-end: 0;

            & > * {
              border-block-end: 1px solid var(--shape-stroke-color);
            }

            &:last-child {
              border-block-end: 0;
            }
          }

          [data-header] {
            display: none;
          }

          [data-title] {
            grid-area: title;
            grid-column: auto;
            grid-column: span 2;
          }

          [data-duration] {
            grid-area: duration;
          }

          [data-instruction] {
            grid-area: instruction;
          }

          [data-method] {
            grid-area: method;
          }

          [data-media] {
            grid-area: media;
          }
        }
      }
    }
  </style>
</template>;

export { ExerciseDetails };
