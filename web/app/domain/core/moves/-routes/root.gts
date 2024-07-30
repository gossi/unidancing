import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

export class MovesRootRoute extends Route<object> {
  <template>
    {{pageTitle 'Moves'}}

    {{outlet}}
  </template>
}

export default CompatRoute(MovesRootRoute);
