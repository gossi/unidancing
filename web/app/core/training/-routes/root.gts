import { pageTitle } from 'ember-page-title';
import { LinkTo } from '@ember/routing';
import styles from './styles.css';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

export class TrainingRootRoute extends Route<{}> {
  <template>
    {{pageTitle 'Training'}}

    <header class={{styles.header}}>
      <h1>Training</h1>

      <nav>
        <ul>
          <li><LinkTo @route='training'>Übersicht</LinkTo></li>
          <li><LinkTo @route='training.planning'>Planung</LinkTo></li>
          <li><LinkTo @route='training.control'>Steuerung</LinkTo></li>
          <li><LinkTo @route='training.diagnostics'>Diagnostik</LinkTo></li>
        </ul>
      </nav>
    </header>

    {{outlet}}
  </template>
}

export default CompatRoute(TrainingRootRoute);
