import { link } from 'ember-link';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';
import { decompressFromEncodedURIComponent } from 'lz-string';

import { Page } from '@hokulea/ember';

import { scoreArtistic } from '../../routines/artistic/actions';
import { RoutineResults } from '../../routines/results';
import { loadSystem, loadSystemDescriptor } from '../../routines/systems/actions';
import { evaluateTimeTracking } from '../../routines/time-tracking/domain';

import type { RoutineResult, RoutineTest } from '../../routines/domain-objects';
import type { WireTimeTracking } from '../../routines/time-tracking/domain';

export class ChoreographyRoutineResultsRoute extends Route<{ data: string }> {
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

  <template>
    <Page @title="Kür Analyse">
      <RoutineResults
        @data={{this.data}}
        @editLink={{link "choreography.routines.test.load" this.params.data}}
      />
    </Page>
  </template>
}

export default CompatRoute(ChoreographyRoutineResultsRoute);
