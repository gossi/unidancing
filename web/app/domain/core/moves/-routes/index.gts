import { cached } from '@glimmer/tracking';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';
import { use } from 'ember-resources';
import Task from 'ember-tasks';

import { Page } from '@hokulea/ember';

import { MoveTeaser } from '../-components';
import { findMoves } from '../-resource';

export class CourseIndexRoute extends Route<{ id: string }> {
  @cached
  get load() {
    const promise = use(this, findMoves()).current;

    return Task.promise(promise);
  }

  <template>
    <Page
      @title="Moves"
      @description="Spezielle Auswahl von Bewegungen und Körpertechniken für Einradfahrer, die deiner Kür Charakter verleihen."
    >
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
