import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import { RoutineTesterForm } from '../routine-tester/form';

export class ChoreographyRoutineTesterRoute extends Route<object> {
  <template><RoutineTesterForm /></template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(ChoreographyRoutineTesterRoute);
