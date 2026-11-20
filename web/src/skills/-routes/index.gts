import { cached } from '@glimmer/tracking';
import { LinkTo } from '@ember/routing';

import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';
import { use } from 'ember-resources';
import Task from 'ember-tasks';

import { Page } from '@hokulea/ember';

import { findSkills } from '../-resource';

export class CourseIndexRoute extends Route<object> {
  @cached
  get load() {
    const promise = use(this, findSkills()).current;

    return Task.promise(promise);
  }

  <template>
    {{pageTitle "Fertigkeiten"}}

    <Page @title="Fertigkeiten">
      {{#let this.load as |r|}}
        {{#if r.resolved}}
          <ul>
            {{#each r.value as |skill|}}
              <li>
                <LinkTo
                  @route="skills.details"
                  @model={{skill._sys.filename}}
                >{{skill.title}}</LinkTo>
              </li>
            {{/each}}
          </ul>
        {{/if}}
      {{/let}}
    </Page>
  </template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(CourseIndexRoute);
