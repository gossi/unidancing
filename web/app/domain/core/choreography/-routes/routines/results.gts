import { link } from 'ember-link';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';
import { decompressFromEncodedURIComponent } from 'lz-string';

import { Page } from '@hokulea/ember';

import { RoutineResults } from '../../routines/results';

export class ChoreographyRoutineResultsRoute extends Route<{ data: string }> {
  get data() {
    const data = JSON.parse(decompressFromEncodedURIComponent(this.params.data));

    console.log(this.params, data);

    return data;
  }

  <template>
    <Page @title="Kür Ergebnisse">
      <RoutineResults
        @data={{this.data}}
        @editLink={{link "choreography.routines.test.load" this.params.data}}
      />
    </Page>
  </template>
}

export default CompatRoute(ChoreographyRoutineResultsRoute);
