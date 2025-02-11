import { service } from '@ember/service';

import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';
import { compressToEncodedURIComponent, decompressFromEncodedURIComponent } from 'lz-string';

import { Page } from '@hokulea/ember';

import { TrainingTesterForm } from '../training/form';

import type { TrainingResult } from '../training/domain-objects';
import type RouterService from '@ember/routing/router-service';

export class RoutineTrainingRoute extends Route<{ data?: string }> {
  @service('router') declare emberRouter: RouterService;

  gotoResults = (data: TrainingResult) => {
    const qs = compressToEncodedURIComponent(JSON.stringify(data));

    this.emberRouter.transitionTo('choreography.routines.training.results', qs);
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
    {{pageTitle "Kür Wertungs-Training"}}

    <Page @title="Kür Wertungs-Training">
      <TrainingTesterForm @submit={{this.gotoResults}} @data={{this.data}} />
    </Page>
  </template>
}

export default CompatRoute(RoutineTrainingRoute);
