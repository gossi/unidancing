import { cached } from '@glimmer/tracking';
import { concat } from '@ember/helper';
import { service } from '@ember/service';

import { t } from 'ember-intl';
import formatDate from 'ember-intl/helpers/format-date';
import { link } from 'ember-link';
import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';
import { use } from 'ember-resources';
import Task from 'ember-tasks';
import { or } from 'ember-truth-helpers';
import { compressToEncodedURIComponent } from 'lz-string';

import { IconButton, Page } from '@hokulea/ember';

import { Share, Toolbar } from '../analysis/-components';
import { findRoutine } from '../analysis/-resource';
import { type RoutineResult } from '../analysis/domain-objects';
import { RoutineResults } from '../analysis/results';

import type FastbootService from 'ember-cli-fastboot/services/fastboot';

function toUrlParam(data: RoutineResult) {
  return compressToEncodedURIComponent(JSON.stringify(data));
}

export class RoutineDetailsRoute extends Route<{ path: string }> {
  @service declare fastboot: FastbootService;

  @cached
  get load() {
    const promise = use(this, findRoutine(this.params.path)).current;

    if (this.fastboot.isFastBoot) {
      this.fastboot.deferRendering(promise);
    }

    return Task.promise(promise);
  }

  <template>
    {{#let this.load as |r|}}
      {{#if r.resolved}}
        {{#let (concat r.value.rider (if r.value.event (concat " @ " r.value.event))) as |title|}}
          {{pageTitle title}}
          <Page @title={{title}}>
            <:description>
              {{#if (or r.value.type r.value.date)}}
                <p>
                  {{#if r.value.type}}
                    {{t (concat "choreography.routines.type." r.value.type)}}
                  {{/if}}

                  {{#if r.value.date}}
                    <time datetime={{r.value.date}}>{{formatDate r.value.date}}</time>
                  {{/if}}
                </p>
              {{/if}}

              <Toolbar>
                <Share @routine={{r.value}} />

                <IconButton
                  @icon="pencil-simple"
                  @importance="subtle"
                  @spacing="-1"
                  @label="Bearbeiten"
                  @push={{link "choreography.routines.test_load" (toUrlParam r.value)}}
                />
              </Toolbar>
            </:description>
            <:content>
              <RoutineResults @data={{r.value}} />
            </:content>
          </Page>
        {{/let}}
      {{/if}}
    {{/let}}
  </template>
}

export default CompatRoute(RoutineDetailsRoute);
