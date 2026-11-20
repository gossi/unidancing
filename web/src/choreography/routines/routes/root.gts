import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

export class RoutinesRoute extends Route<object> {
  <template>{{outlet}}</template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(RoutinesRoute);
