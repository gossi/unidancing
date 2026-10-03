import { cached } from '@glimmer/tracking';
import { LinkTo } from '@ember/routing';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';
import { use } from 'ember-resources';
import Task from 'ember-tasks';

import { Page } from '@hokulea/ember';

import { ExerciseTeaser } from '../-components';
import { findExercises } from '../-resource';
import styles from './styles.module.css';

export class ExercisesIndexRoute extends Route<object> {
  findExercises = use(this, findExercises());

  @cached
  get load() {
    const promise = this.findExercises.current;

    return Task.promise(promise);
  }

  <template>
    <Page>
      <:title>Übungen</:title>
      <:description>
        Zum Lernen von
        <LinkTo @route="moves">Moves</LinkTo>
        und
        <LinkTo @route="arts">Körperkünsten</LinkTo>. Unter
        <LinkTo @route="training.planning.units">Trainingsgestaltung</LinkTo>
        ist der Einsatz für's Training beschrieben.
      </:description>

      <:content>
        <div class={{styles.listing}}>
          {{#let this.load as |r|}}
            {{#if r.resolved}}
              {{#each r.value as |exercise|}}
                <ExerciseTeaser @exercise={{exercise}} />
              {{/each}}
            {{/if}}
          {{/let}}
        </div>
      </:content>
    </Page>
  </template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(ExercisesIndexRoute);
