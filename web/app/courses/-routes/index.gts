import { pageTitle } from 'ember-page-title';
import { findCourses } from '../resource';
import { service } from '@ember/service';
import { use } from 'ember-resources';
import Task from 'ember-tasks';
import { LinkTo } from '@ember/routing';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import type FastbootService from 'ember-cli-fastboot/services/fastboot';

export class CourseIndexRoute extends Route<{ id: string }> {
  @service declare fastboot: FastbootService;

  promise = use(this, findCourses()).current;

  get load() {
    if (this.fastboot.isFastBoot) {
      this.fastboot.deferRendering(this.promise);
    }

    return Task.promise(this.promise);
  }

  <template>
    {{pageTitle 'Kurse'}}
    <h1>Kurse</h1>

    {{#let this.load as |r|}}
      {{#if r.resolved}}
        {{#each r.value as |course|}}
          <article>
            <header><LinkTo
                @route='courses.details'
                @model={{course._sys.filename}}
              >{{course.title}}</LinkTo></header>

            <p>{{course.description}}</p>
          </article>
        {{/each}}
      {{/if}}
    {{/let}}
  </template>
}

export default CompatRoute(CourseIndexRoute);
