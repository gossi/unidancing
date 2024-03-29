import { Icon, VideoPlayer } from '../../../supporting/ui';
import { asString } from '../../../supporting/utils';
import { formatPersonal, formatLocomotion, asPersonal, asLocomotion } from '../-helpers';
import { on } from '@ember/modifier';
import styles from './details.css';
import { TinaMarkdown } from '../../../supporting/tina';
import { or } from 'ember-truth-helpers';
import { buildExerciseLink } from '../-resource';
import { buildGameLink } from '../../games';
import { buildSkillLink } from '../../skills';

import type { Exercise, ExerciseGamesDancemix } from '..';
import type { Maybe } from '@/tina/types';
import type { TOC } from '@ember/component/template-only';

export interface ExerciseDetailsSignature {
  Args: {
    exercise: Exercise;
  };
}

const nonGameParamKeys = ['__typename', 'name', 'label'];
const filterGameParams = (game: Maybe<ExerciseGamesDancemix>) => {
  if (!game) return {};

  const params: Record<string, unknown> = {};
  for (const [k, v] of Object.entries(game)) {
    if (!nonGameParamKeys.includes(k)) {
      params[k] = v;
    }
  }

  return params;
};

const ExerciseDetails: TOC<ExerciseDetailsSignature> = <template>
  <hgroup>
    <h1><Icon @icon='exercise' /> {{@exercise.title}}</h1>
    <span class={{styles.tagline}}>
      {{#each @exercise.personal as |personal|}}
        {{formatPersonal (asPersonal personal) text=true}}
      {{/each}}

      {{#each @exercise.locomotion as |locomotion|}}
        {{formatLocomotion (asLocomotion locomotion) text=true}}
      {{/each}}

      {{#each @exercise.tags as |tag|}}
        <code>{{tag}}</code>
      {{/each}}
    </span>
  </hgroup>

  <div class={{styles.layout}}>
    <section class={{styles.main}}>
      {{#if @exercise.games}}
        <header class={{styles.header}}>
          {{#each @exercise.games as |game|}}
            {{#let (buildGameLink (asString game.name) (filterGameParams game)) as |link|}}
              <a href={{link.url}} role='button' {{on 'click' link.transitionTo}}>
                {{#if game.label}}{{game.label}}{{else}}{{game.name}}{{/if}}
              </a>
            {{/let}}
          {{/each}}
        </header>
      {{/if}}

      {{#if @exercise.video}}
        <VideoPlayer @url={{@exercise.video}} class={{styles.player}}/>
      {{/if}}

      <TinaMarkdown @content={{@exercise.body}} />
    </section>

    {{#if (or @exercise.links @exercise.exercises @exercise.skills @exercise.material)}}
      <aside>
        <section>
          {{#if (or @exercise.links @exercise.exercises)}}
            <nav>
              Siehe auch:

              <ul>
                {{#each @exercise.exercises as |ex|}}
                  <li>
                    {{#let (buildExerciseLink (asString ex.data._sys.filename)) as |l|}}
                      <a href={{l.url}} {{on 'click' l.transitionTo}}>
                        <Icon @icon='exercise' />
                        {{ex.data.title}}
                      </a>
                    {{/let}}
                  </li>
                {{/each}}

                {{#each @exercise.links as |see|}}
                  <li>
                    <a href={{see.url}} target='_blank'>
                      <Icon @icon='link' />
                      {{if see.label see.label see.url}}
                    </a>
                  </li>
                {{/each}}
              </ul>
            </nav>
          {{/if}}

          {{#if @exercise.skills}}
            <nav>
              Fertigkeiten:

              <ul>
                {{#each @exercise.skills as |skill|}}
                  <li>
                    {{#let (buildSkillLink (asString skill.data._sys.filename)) as |l|}}
                      <a href={{l.url}} {{on 'click' l.transitionTo}}>
                        <Icon @icon='skill' />
                        {{skill.data.title}}
                      </a>
                    {{/let}}
                  </li>
                {{/each}}
              </ul>
            </nav>
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
</template>;

export { ExerciseDetails };
