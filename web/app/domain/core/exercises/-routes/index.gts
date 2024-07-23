import { cached } from '@glimmer/tracking';
import { LinkTo } from '@ember/routing';
import { service } from '@ember/service';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';
import { use } from 'ember-resources';
import Task from 'ember-tasks';

import { Page } from '@hokulea/ember';

import { ExerciseTeaser } from '../-components';
import { findExercises } from '../-resource';

import type FastbootService from 'ember-cli-fastboot/services/fastboot';

export class ExercisesIndexRoute extends Route<object> {
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
    <Page>
      <:title>Übungen</:title>
      <:description>
        Zum Lernen von
        <LinkTo @route='moves'>Moves</LinkTo>
        und
        <LinkTo @route='arts'>Körperkünsten</LinkTo>.
      </:description>

      <:content>
        {{#let this.load as |r|}}
          {{#if r.resolved}}
            {{#each r.value as |exercise|}}
              <ExerciseTeaser @exercise={{exercise}} />
            {{/each}}
          {{/if}}
        {{/let}}
      </:content>
    </Page>
  </template>
}

export default CompatRoute(ExercisesIndexRoute);
