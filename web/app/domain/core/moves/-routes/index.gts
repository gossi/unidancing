import { pageTitle } from 'ember-page-title';
import { findMoves } from '../-resource';
import { service } from '@ember/service';
import { use } from 'ember-resources';
import Task from 'ember-tasks';
import { MoveTeaser } from '../-components';
import { cached } from '@glimmer/tracking';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import type FastbootService from 'ember-cli-fastboot/services/fastboot';

export class CourseIndexRoute extends Route<{ id: string }> {
  @service declare fastboot: FastbootService;

  @cached
  get load() {
    const promise = use(this, findMoves()).current;

    if (this.fastboot.isFastBoot) {
      this.fastboot.deferRendering(promise);
    }

    return Task.promise(promise);
  }

  <template>
    {{pageTitle 'Moves'}}

    <h1>Moves</h1>

    <p>Spezielle Auswahl von Bewegungen und Körpertechniken für Einradfahrer, die deiner Kür
      Charakter verleihen.</p>

    {{#let this.load as |r|}}
      {{#if r.resolved}}
        {{#each r.value as |move|}}
          <MoveTeaser @move={{move}} />
        {{/each}}
      {{/if}}
    {{/let}}
  </template>
}

export default CompatRoute(CourseIndexRoute);
