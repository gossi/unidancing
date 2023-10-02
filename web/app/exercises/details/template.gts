import RouteTemplate from 'ember-route-template';
import pageTitle from 'ember-page-title/helpers/page-title';
import Icon from '../../components/icon';
import { formatPersonal } from '../../helpers/format-personal';
import { formatLocomotion } from '../../helpers/format-locomotion';
import { htmlSafe } from '@ember/template';
import { on } from '@ember/modifier';
import styles from './styles.css';

import type { Exercise } from '../../database/exercises';
import type { GameLinkBuilder } from './route';
import type { GameKey } from '../../games/games';
import type { Link } from 'ember-link';

interface Signature {
  Args: {
    model: {
      exercise: Exercise;
      buildGameLink: GameLinkBuilder<GameKey>;
      buildExerciseLink: (exercise: string) => Link,
      buildSkillLink: (skill: string) => Link,
    }
  }
}

export default RouteTemplate<Signature>(<template>
  {{#let @model.exercise as |exercise|}}
    {{#if exercise}}
      {{pageTitle exercise.title}}

      <hgroup>
        <h1><Icon @icon='exercise' /> {{exercise.title}}</h1>
        <span class={{styles.tagline}}>
          {{#each exercise.personal as |personal|}}
            {{formatPersonal personal text=true}}
          {{/each}}

          {{#each exercise.locomotion as |locomotion|}}
            {{formatLocomotion locomotion text=true}}
          {{/each}}

          {{#each exercise.tags as |tag|}}
            <code>{{tag}}</code>
          {{/each}}
        </span>
      </hgroup>

      <div class={{styles.layout}}>
        <section class={{styles.main}}>
          {{#if exercise.games}}
            <header class={{styles.header}}>
              {{#each exercise.games as |game|}}
                {{#let (@model.buildGameLink game.name game.params) as |link|}}
                  <a
                    href={{link.url}}
                    role='button'
                    {{on 'click' link.transitionTo}}
                  >
                    {{#if game.label}}{{game.label}}{{else}}{{game.name}}{{/if}}
                  </a>
                {{/let}}
              {{/each}}
            </header>
          {{/if}}

          {{htmlSafe exercise.contents}}
        </section>
        <aside>
          <section>
            {{#if exercise.see}}
              <nav>
                Siehe auch:

                <ul>
                  {{#each exercise.see as |see|}}
                    <li>
                      {{#if see.url}}
                        <a href={{see.url}} target='_blank'>
                          <Icon @icon='link' />
                          {{if see.label see.label see.url}}
                        </a>
                      {{else}}
                        {{#let (@model.buildExerciseLink see.id) as |l|}}
                          <a href={{l.url}} {{on 'click' l.transitionTo}}>
                            <Icon @icon='exercise' />
                            {{see.title}}
                          </a>
                        {{/let}}
                      {{/if}}
                    </li>
                  {{/each}}
                </ul>
              </nav>
            {{/if}}

            {{#if exercise.skills}}
              <nav>
                Fertigkeiten:

                <ul>
                  {{#each exercise.skills as |skill|}}
                    <li>
                      {{#let (@model.buildSkillLink skill.id) as |l|}}
                        <a href={{l.url}} {{on 'click' l.transitionTo}}>
                          <Icon @icon='skill' />
                          {{skill.title}}
                        </a>
                      {{/let}}
                    </li>
                  {{/each}}
                </ul>
              </nav>
            {{/if}}
          </section>
        </aside>
      </div>

    {{else}}
      <h1>Not Found</h1>

      <p>whoops</p>
    {{/if}}
  {{/let}}
</template>);
