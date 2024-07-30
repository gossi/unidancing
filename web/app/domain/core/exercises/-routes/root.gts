import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

export class ExerciseRootRoute extends Route<object> {
  <template>
    {{pageTitle 'Übungen'}}

    {{outlet}}
  </template>
}

export default CompatRoute(ExerciseRootRoute);
