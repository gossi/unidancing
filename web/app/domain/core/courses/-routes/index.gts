import { cached } from '@glimmer/tracking';
import { LinkTo } from '@ember/routing';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';
import { use } from 'ember-resources';
import Task from 'ember-tasks';

import { Card, Page } from '@hokulea/ember';

import { findCourses } from '../-resource';

export class CourseIndexRoute extends Route<{ id: string }> {
  @cached
  get load() {
    const promise = use(this, findCourses()).current;

    return Task.promise(promise);
  }

  <template>
    <Page @title="Kurse">
      {{#let this.load as |r|}}
        {{#if r.resolved}}
          {{#each r.value as |course|}}
            <Card>
              <:header>
                <LinkTo
                  @route="courses.details"
                  @model={{course._sys.filename}}
                >{{course.title}}</LinkTo>
              </:header>

              <:body>
                <p>{{course.description}}</p>
              </:body>
            </Card>
          {{/each}}
        {{/if}}
      {{/let}}
    </Page>
  </template>
}

export default CompatRoute(CourseIndexRoute);
