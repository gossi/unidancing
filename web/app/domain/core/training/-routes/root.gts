import { pageTitle } from 'ember-page-title';
import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

import { SectionedPage } from '@hokulea/ember';

export class TrainingRootRoute extends Route<object> {
  <template>
    {{pageTitle "Training"}}

    <SectionedPage>
      <:title>Training</:title>
      <:nav as |Item|>
        <Item @href="/training/">Übersicht</Item>
        <Item @href="/training/leistungsprofil">Leistungsprofil</Item>
        <Item @href="/training/planning">Planung</Item>
        <Item @href="/training/control">Steuerung</Item>
        <Item @href="/training/diagnostics">Diagnostik</Item>
      </:nav>

      <:content>
        {{outlet}}
      </:content>
    </SectionedPage>
  </template>
}

// @ts-expect-error some broken upstream types here
export default CompatRoute(TrainingRootRoute);
