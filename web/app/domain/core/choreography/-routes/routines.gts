import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

export class ChoreographyRoutinesRoute extends Route<object> {
  <template>{{outlet}}</template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(ChoreographyRoutinesRoute);
