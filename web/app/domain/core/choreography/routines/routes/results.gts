import { tracked } from '@glimmer/tracking';
import { concat } from '@ember/helper';
import { isDevelopingApp } from '@embroider/macros';

import { t } from 'ember-intl';
import formatDate from 'ember-intl/helpers/format-date';
import { link } from 'ember-link';
import { modifier } from 'ember-modifier';
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
import styles from './styles.css';

import type { RoutineResult, RoutineTest } from '../analysis/domain-objects';
import type { WireTimeTracking } from '../analysis/time-tracking/domain';

const selectWhenFocus = modifier((element: HTMLInputElement | HTMLTextAreaElement) => {
  const handler = () => {
    window.setTimeout(() => element.setSelectionRange(0, element.value.length), 0);
  };

  element.addEventListener('focus', handler);

  return () => {
    element.removeEventListener('focus', handler);
  };
});

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

  copyLink = () => {
    window.navigator.clipboard.writeText(this.shareLink);
  };

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
                    @push={{this.copyLink}}
                  />
                </div>
              </Popover>
            {{/let}}
            <IconButton
              @icon="pencil-simple"
              @importance="subtle"
              @spacing="-1"
              @label="Bearbeiten"
              @push={{link "choreography.routines.test" this.params.data}}
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
