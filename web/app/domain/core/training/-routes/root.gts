import { link } from 'ember-link';
import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import { Page } from '@hokulea/ember';

export class TrainingRootRoute extends Route<object> {
  <template>
    {{pageTitle "Training"}}

    <Page>
      <:title>Training</:title>
      <:nav as |Item|>
        <Item @link={{link "training.index"}}>Übersicht</Item>
        <Item @link={{link "training.planning"}}>Planung</Item>
        <Item @link={{link "training.control"}}>Steuerung</Item>
        <Item @link={{link "training.diagnostics"}}>Diagnostik</Item>
      </:nav>

      <:content>
        {{outlet}}
      </:content>
    </Page>
  </template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(TrainingRootRoute);
