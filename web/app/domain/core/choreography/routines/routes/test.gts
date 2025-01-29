import { service } from '@ember/service';

import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';
import { compressToEncodedURIComponent, decompressFromEncodedURIComponent } from 'lz-string';

import { Page } from '@hokulea/ember';

import { RoutineTesterForm } from '../analysis/form';

import type { RoutineTest } from '../analysis/domain-objects';
import type RouterService from '@ember/routing/router-service';

export class ChoreographyRoutineTesterRoute extends Route<{ data?: string }> {
  @service('router') declare emberRouter: RouterService;

  gotoResults = (data: RoutineTest) => {
    const qs = compressToEncodedURIComponent(JSON.stringify(data));

    this.emberRouter.transitionTo('choreography.routines.results', qs);
  };

  get data() {
    try {
      if (this.params.data) {
        const data = JSON.parse(decompressFromEncodedURIComponent(this.params.data));

        return data;
      }
    } catch {
      return undefined;
    }

    return undefined;
  }

  <template>
    {{pageTitle "Kür Analyse"}}

    <Page @title="Kür Analyse">
      <RoutineTesterForm @submit={{this.gotoResults}} @data={{this.data}} />
    </Page>
  </template>
}

export default CompatRoute(ChoreographyRoutineTesterRoute);
