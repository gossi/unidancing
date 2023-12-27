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

  get courses() {
    const promise = use(this, findCourses()).current;

    if (this.fastboot.isFastBoot) {
      this.fastboot.deferRendering(promise);
    }

    return Task.promise(promise);
  }

  <template>
    {{pageTitle 'Kurse'}}
    <h1>Kurse</h1>

    {{#let this.courses as |r|}}
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
