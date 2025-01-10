import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

export class ChoreographyRoutinesIndexRoute extends Route<object> {
  <template>
    <h2>Küren</h2>
  </template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(ChoreographyRoutinesIndexRoute);
