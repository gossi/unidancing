import { pageTitle } from 'ember-page-title';
import { ExerciseDetails } from '../-components';
import { findExercise } from '../resource';
import { service } from '@ember/service';
import { use } from 'ember-resources';
import Task from 'ember-tasks';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import type FastbootService from 'ember-cli-fastboot/services/fastboot';

export class ExerciseDetailsRoute extends Route<{ id: string }> {
  @service declare fastboot: FastbootService;

  get exercise() {
    const promise = use(this, findExercise(this.params.id)).current;

    if (this.fastboot.isFastBoot) {
      this.fastboot.deferRendering(promise);
    }

    return Task.promise(promise);
  }

  <template>
    {{#let this.exercise as |r|}}
      {{#if r.resolved}}
        {{pageTitle r.value.title}}

        <ExerciseDetails @exercise={{r.value}} />
      {{/if}}
    {{/let}}
  </template>
}

export default CompatRoute(ExerciseDetailsRoute);
