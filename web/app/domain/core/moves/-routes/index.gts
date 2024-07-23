import { cached } from '@glimmer/tracking';
import { service } from '@ember/service';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';
import { use } from 'ember-resources';
import Task from 'ember-tasks';

import { Page } from '@hokulea/ember';

import { MoveTeaser } from '../-components';
import { findMoves } from '../-resource';

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
    <Page @title="Moves" @description="Spezielle Auswahl von Bewegungen und Körpertechniken für Einradfahrer, die deiner Kür Charakter verleihen.">
      {{#let this.load as |r|}}
        {{#if r.resolved}}
          {{#each r.value as |move|}}
            <MoveTeaser @move={{move}} />
          {{/each}}
        {{/if}}
      {{/let}}
    </Page>
  </template>
}

export default CompatRoute(CourseIndexRoute);
