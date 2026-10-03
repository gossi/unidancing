import { cached } from '@glimmer/tracking';

import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';
import { use } from 'ember-resources';
import Task from 'ember-tasks';

import { ArtDetails } from '../-components';
import { findArt } from '../-resource';

export class CourseDetailsRoute extends Route<{ id: string }> {
  @cached
  get load() {
    const promise = use(this, findArt(this.params.id)).current;

    return Task.promise(promise);
  }

  <template>
    {{#let this.load as |r|}}
      {{#if r.resolved}}
        {{pageTitle r.value.title}}

        <ArtDetails @art={{r.value}} />
      {{/if}}
    {{/let}}
  </template>
}

export default CompatRoute(CourseDetailsRoute);
