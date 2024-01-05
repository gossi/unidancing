import { pageTitle } from 'ember-page-title';
import { TinaMarkdown } from '../../components';
import { findSkill } from '../resource';
import { service } from '@ember/service';
import { use } from 'ember-resources';
import Task from 'ember-tasks';
import { cached } from '@glimmer/tracking';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import type FastbootService from 'ember-cli-fastboot/services/fastboot';

export class CourseDetailsRoute extends Route<{ id: string }> {
  @service declare fastboot: FastbootService;

  @cached
  get load() {
    const promise = use(this, findSkill(this.params.id)).current;

    if (this.fastboot.isFastBoot) {
      this.fastboot.deferRendering(promise);
    }

    return Task.promise(promise);
  }

  <template>
    {{#let this.load as |r|}}
      {{#if r.resolved}}
        {{pageTitle r.value.title}}

        <section>
          <h1>{{r.value.title}}</h1>

          <TinaMarkdown @content={{r.value.body}} />
        </section>
      {{/if}}
    {{/let}}
  </template>
}

export default CompatRoute(CourseDetailsRoute);
