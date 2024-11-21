import { service } from '@ember/service';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';
import { compressToEncodedURIComponent, decompressFromEncodedURIComponent } from 'lz-string';

import { Page } from '@hokulea/ember';

import { RoutineTesterForm } from '../../routines/form';

import type { RoutineTest } from '../../routines/domain-objects';
import type RouterService from '@ember/routing/router-service';

export class ChoreographyRoutineTesterRoute extends Route<{ data?: string }> {
  @service('router') declare emberRouter: RouterService;

  gotoResults = (data: RoutineTest) => {
    const qs = compressToEncodedURIComponent(JSON.stringify(data));

    this.emberRouter.transitionTo('choreography.routines.results', qs);
  };

  get data() {
    // console.log(this.params, this.emberRouter);

    try {
      if (this.params.data) {
        const data = JSON.parse(decompressFromEncodedURIComponent(this.params.data));

        // console.log(data);

        return data;
      }
    } catch {
      return undefined;
    }

    return undefined;
  }

  <template>
    <Page @title="Kür-Test">
      <RoutineTesterForm @submit={{this.gotoResults}} @data={{this.data}} />
    </Page>
  </template>
}

export default CompatRoute(ChoreographyRoutineTesterRoute);
