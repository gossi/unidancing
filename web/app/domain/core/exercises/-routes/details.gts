import { cached } from '@glimmer/tracking';

import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';
import { use } from 'ember-resources';
import Task from 'ember-tasks';

import { ExerciseDetails } from '../-components';
import { findExercise } from '../-resource';

export class ExerciseDetailsRoute extends Route<{ id: string }> {
  @cached
  get load() {
    const promise = use(this, findExercise(this.params.id)).current;

    return Task.promise(promise);
  }

  <template>
    {{#let this.load as |r|}}
      {{#if r.resolved}}
        {{pageTitle r.value.title}}

        <ExerciseDetails @exercise={{r.value}} />
      {{/if}}
    {{/let}}
  </template>
}

export default CompatRoute(ExerciseDetailsRoute);
