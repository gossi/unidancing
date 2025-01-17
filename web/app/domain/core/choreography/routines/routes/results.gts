import { tracked } from '@glimmer/tracking';
import { concat } from '@ember/helper';
import { fn } from '@ember/helper';
import { isDevelopingApp } from '@embroider/macros';

import { t } from 'ember-intl';
import formatDate from 'ember-intl/helpers/format-date';
import { link } from 'ember-link';
import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';
import { or } from 'ember-truth-helpers';
import { decompressFromEncodedURIComponent } from 'lz-string';

import { IconButton, Page, Popover, popover, TextArea, TextInput } from '@hokulea/ember';

import { scoreArtistic } from '../analysis/artistic/actions';
import { RoutineResults } from '../analysis/results';
import { loadSystem, loadSystemDescriptor } from '../analysis/systems/actions';
import { evaluateTimeTracking } from '../analysis/time-tracking/domain';
import { copyToClipboard, selectWhenFocus } from './-utils';
import styles from './styles.css';

import type { RoutineResult, RoutineTest } from '../analysis/domain-objects';
import type { WireTimeTracking } from '../analysis/time-tracking/domain';

export class ChoreographyRoutineResultsRoute extends Route<{ data: string }> {
  @tracked exportShown = false;

  get data() {
    const data = JSON.parse(decompressFromEncodedURIComponent(this.params.data)) as RoutineTest;
    const results: Partial<RoutineResult> = {
      rider: data.rider,
      type: data.type,
      date: data.date,
      event: data.event,
      video: data.video,
      notTodoList: data.notTodoList
    };

    if (data.artistic) {
      const system = loadSystem(loadSystemDescriptor(data.artistic.name));

      results.artistic = scoreArtistic(system, data.artistic);
    }

    if (data.timeTracking) {
      results.timeTracking = {
        ...(data.timeTracking as WireTimeTracking),
        ...evaluateTimeTracking(data.timeTracking as WireTimeTracking)
      };
    }

    return results as RoutineResult;
  }

  get shareLink() {
    try {
      return window.location.href;
    } catch {
      return '';
    }
  }

  get exportLink() {
    const url = new URL(this.shareLink);

    url.hostname = 'unidancing.art';
    url.port = '';
    url.protocol = 'https';

    return url.toString();
  }

  get exportData() {
    return JSON.stringify(this.data, null, '  ');
  }

  toggleExport = () => {
    this.exportShown = !this.exportShown;
  };

  exportAvailable = isDevelopingApp();

  <template>
    {{#let (concat this.data.rider (if this.data.event (concat " @ " this.data.event))) as |title|}}
      {{pageTitle title}}
      <Page @title={{title}}>
        <:description>
          {{#if (or this.data.type this.data.date)}}
            <p>
              {{#if this.data.type}}
                {{t (concat "choreography.routines.type." this.data.type)}}
              {{/if}}

              {{#if this.data.date}}
                <time datetime={{this.data.date}}>{{formatDate this.data.date}}</time>
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
              @push={{link "choreography.routines.test_load" this.params.data}}
            />
            {{#if this.exportAvailable}}
              <IconButton
                @icon="download-simple"
                @importance="subtle"
                @spacing="-1"
                @label="Speichern"
                @push={{this.toggleExport}}
                aria-pressed={{this.exportShown}}
              />

              {{#let (popover position="bottom-start") as |po|}}
                <IconButton
                  @icon="export"
                  @importance="subtle"
                  @spacing="-1"
                  @label="Teilen auf unidancing.art"
                  {{po.trigger}}
                />

                <Popover {{po.target}} class={{styles.share}}>
                  <p>Teile den Link zur Kür-Analyse auf unidancing.art:</p>
                  <div>
                    <TextInput @value={{this.exportLink}} readonly {{selectWhenFocus}} />
                    <IconButton
                      @icon="clipboard-text"
                      @importance="subtle"
                      @spacing="-1"
                      @label="Kopieren"
                      @push={{fn copyToClipboard this.exportLink}}
                    />
                  </div>
                </Popover>
              {{/let}}
            {{/if}}
          </p>

          {{#if this.exportShown}}
            <TextArea
              @value={{this.exportData}}
              class={{styles.exportData}}
              readonly
              {{selectWhenFocus}}
            />
          {{/if}}
        </:description>
        <:content>
          <RoutineResults @data={{this.data}} />
        </:content>
      </Page>
    {{/let}}
  </template>
}

export default CompatRoute(ChoreographyRoutineResultsRoute);
