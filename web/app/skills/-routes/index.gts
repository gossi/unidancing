import { pageTitle } from 'ember-page-title';
import { findSkills } from '../resource';
import { service } from '@ember/service';
import { use } from 'ember-resources';
import Task from 'ember-tasks';
import { LinkTo } from '@ember/routing';
import { cached } from '@glimmer/tracking';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import type FastbootService from 'ember-cli-fastboot/services/fastboot';

export class CourseIndexRoute extends Route<{ id: string }> {
  @service declare fastboot: FastbootService;

  @cached
  get load() {
    const promise = use(this, findSkills()).current;

    if (this.fastboot.isFastBoot) {
      this.fastboot.deferRendering(promise);
    }

    return Task.promise(promise);
  }

  <template>
    {{pageTitle "Fertigkeiten"}}

    <h1>Fertigkeiten</h1>

    {{#let this.load as |r|}}
      {{#if r.resolved}}
        <ul>
          {{#each r.value as |skill|}}
            <li>
              <LinkTo @route="skills.details" @model={{skill._sys.filename}}>{{skill.title}}</LinkTo>
            </li>
          {{/each}}
        </ul>
      {{/if}}
    {{/let}}
  </template>
}

export default CompatRoute(CourseIndexRoute);
