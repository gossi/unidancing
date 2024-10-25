import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

export class CoursesRootRoute extends Route<object> {
  <template>
    {{pageTitle "Kurse"}}

    {{outlet}}
  </template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(CoursesRootRoute);
