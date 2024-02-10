import { LinkTo } from '@ember/routing';
import { ExerciseTeaser } from '../-components';
import { findExercises } from '../-resource';
import { service } from '@ember/service';
import { use } from 'ember-resources';
import Task from 'ember-tasks';
import { cached } from '@glimmer/tracking';

import type FastbootService from 'ember-cli-fastboot/services/fastboot';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

export class ExercisesIndexRoute extends Route<{}> {
  @service declare fastboot: FastbootService;

  findExercises = use(this, findExercises());

  @cached
  get load() {
    const promise = this.findExercises.current;

    if (this.fastboot.isFastBoot) {
      this.fastboot.deferRendering(promise);
    }

    return Task.promise(promise);
  }

  <template>
    <h1>Übungen</h1>

    <p>Zum Lernen von
      <LinkTo @route='moves'>Moves</LinkTo>
      und
      <LinkTo @route='arts'>Körperkünsten</LinkTo>.</p>

    {{#let this.load as |r|}}
      {{#if r.resolved}}
        {{#each r.value as |exercise|}}
          <ExerciseTeaser @exercise={{exercise}} />
        {{/each}}
      {{/if}}
    {{/let}}
  </template>
}

export default CompatRoute(ExercisesIndexRoute);
