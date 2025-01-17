import { cached } from '@glimmer/tracking';
import { concat } from '@ember/helper';
import { fn } from '@ember/helper';
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

import { IconButton, Page, Popover, popover, TextInput } from '@hokulea/ember';

import { findRoutine } from '../analysis/-resource';
import { RoutineResults } from '../analysis/results';
import { copyToClipboard, selectWhenFocus } from './-utils';
import styles from './styles.css';

import type { RoutineResult } from '../analysis/domain-objects';
import type FastbootService from 'ember-cli-fastboot/services/fastboot';

function toUrlParam(data: RoutineResult) {
  return compressToEncodedURIComponent(JSON.stringify(data));
}

export class ChoreographyRoutineDetailsRoute extends Route<{ path: string }> {
  @service declare fastboot: FastbootService;

  get shareLink() {
    try {
      return window.location.href;
    } catch {
      return '';
    }
  }

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

              <p class={{styles.toolbar}}>
                {{#let (popover position="bottom-start") as |po|}}
                  <IconButton
                    @icon="share-fat"
                    @importance="subtle"
                    @spacing="-1"
                    @label="Teilen"
                    {{po.trigger}}
                  />

                  <Popover {{po.target}} class={{styles.share}}>
                    <p>Teile den Link zur Kür-Analyse:</p>
                    <div>
                      <TextInput @value={{this.shareLink}} readonly {{selectWhenFocus}} />
                      <IconButton
                        @icon="clipboard-text"
                        @importance="subtle"
                        @spacing="-1"
                        @label="Kopieren"
                        @push={{fn copyToClipboard this.shareLink}}
                      />
                    </div>
                  </Popover>
                {{/let}}
                <IconButton
                  @icon="pencil-simple"
                  @importance="subtle"
                  @spacing="-1"
                  @label="Bearbeiten"
                  @push={{link "choreography.routines.test_load" (toUrlParam r.value)}}
                />
              </p>
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

export default CompatRoute(ChoreographyRoutineDetailsRoute);
