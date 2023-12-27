import { pageTitle } from 'ember-page-title';
import { ArtDetails } from '../-components';
import { findArt } from '../resource';
import { service } from '@ember/service';
import { use } from 'ember-resources';
import Task from 'ember-tasks';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import type FastbootService from 'ember-cli-fastboot/services/fastboot';

export class CourseDetailsRoute extends Route<{ id: string }> {
  @service declare fastboot: FastbootService;

  get art() {
    const promise = use(this, findArt(this.params.id)).current;

    if (this.fastboot.isFastBoot) {
      this.fastboot.deferRendering(promise);
    }

    return Task.promise(promise);
  }

  <template>
    {{#let this.art as |r|}}
      {{#if r.resolved}}
        {{pageTitle r.value.title}}

      <div>
        <ArtDetails @art={{r.value}}/>
      </div>
      {{/if}}
    {{/let}}
  </template>
}

export default CompatRoute(CourseDetailsRoute);
