import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import { SectionedPage } from '@hokulea/ember';

export class ChoreographyRootRoute extends Route<object> {
  <template>
    {{pageTitle "Choreographie"}}

    <SectionedPage>
      <:title>Choreographie</:title>
      <:nav as |Item|>
        <Item @href="/choreography">Übersicht</Item>
        <Item @href="/choreography/routines">Küren</Item>
        <Item @href="/choreography/unidance-writing">UniDance Writing</Item>
        <Item @href="/choreography/not-todo-list">Not Todo Liste</Item>
      </:nav>

      <:content>
        {{outlet}}
      </:content>
    </SectionedPage>
  </template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(ChoreographyRootRoute);
