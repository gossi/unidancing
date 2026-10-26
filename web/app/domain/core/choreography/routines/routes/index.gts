import './routines.css';

import { cached } from '@glimmer/tracking';

import { link } from 'ember-link';
import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';
import { use } from 'ember-resources';
import Task from 'ember-tasks';

import { Button, Page } from '@hokulea/ember';

import { findRoutines } from '../analysis/-resource';
import { Routines } from '../analysis/routines';

export class RoutinesIndexRoute extends Route<object> {
  @cached
  get load() {
    const promise = use(this, findRoutines()).current;

    return Task.promise(promise);
  }

  <template>
    {{pageTitle "Küren"}}

    <Page @title="Küren">
      <p>
        <Button @push={{link "choreography.routines.test"}}>Küranalyse starten</Button>
      </p>

      {{#let this.load as |r|}}
        {{#if r.resolved}}
          <Routines @routines={{r.value}} />
        {{/if}}
      {{/let}}
    </Page>
  </template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(RoutinesIndexRoute);
