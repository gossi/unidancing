import { pageTitle } from 'ember-page-title';
import { CourseDetails } from '../-components';
import { findCourse } from '../resource';
import { service } from '@ember/service';
import { use } from 'ember-resources';
import Task from 'ember-tasks';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import type FastbootService from 'ember-cli-fastboot/services/fastboot';

export class CourseDetailsRoute extends Route<{ id: string }> {
  @service declare fastboot: FastbootService;

  promise = use(this, findCourse(this.params.id)).current;

  get load() {
    if (this.fastboot.isFastBoot) {
      this.fastboot.deferRendering(this.promise);
    }

    return Task.promise(this.promise);
  }

  <template>
    {{#let this.load as |r|}}
      {{#if r.resolved}}
        {{pageTitle r.value.title}}

        <CourseDetails @course={{r.value}} />
      {{/if}}
    {{/let}}
  </template>
}

export default CompatRoute(CourseDetailsRoute);
