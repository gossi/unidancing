import { cached } from '@glimmer/tracking';

import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';
import { use } from 'ember-resources';
import Task from 'ember-tasks';

import { Page } from '@hokulea/ember';

import { ArtTree } from '../-components';
import { findArts } from '../-resource';

export class ArtsIndexRoute extends Route<object> {
  @cached
  get load() {
    const promise = use(this, findArts()).current;

    return Task.promise(promise);
  }

  <template>
    {{pageTitle "Künste"}}

    <Page
      @title="Künste"
      @description="Kunstformen die für UniDancing und deren Umsetzung auf dem Einrad geeignet sind."
    >
      {{#let this.load as |r|}}
        {{#if r.resolved}}
          <div class="layout">
            <ArtTree @arts={{r.value}} />

            {{outlet}}
          </div>
        {{/if}}
      {{/let}}
    </Page>

    <style scoped>
      .layout {
        display: grid;
        gap: var(--s1);
        grid-template-columns: max-content 1fr;

        ul {
          padding-left: calc(var(--spacing-primitive-3) * 2);
        }
      }
    </style>
  </template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(ArtsIndexRoute);
