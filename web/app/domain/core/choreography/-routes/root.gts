import { link } from 'ember-link';
import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import { Page } from '@hokulea/ember';

export class ChoreographyRootRoute extends Route<object> {
  <template>
    {{pageTitle "Choreographie"}}

    <Page>
      <:title>Choreographie</:title>
      <:nav as |Item|>
        <Item @link={{link "choreography.index"}}>Übersicht</Item>
        <Item @link={{link "choreography.routines"}}>Küren</Item>
        <Item @link={{link "choreography.unidance-writing"}}>UniDance Writing</Item>
        <Item @link={{link "choreography.not-todo-list"}}>Not Todo Liste</Item>
      </:nav>

      <:content>
        {{outlet}}
      </:content>
    </Page>
  </template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(ChoreographyRootRoute);
