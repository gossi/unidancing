import { pageTitle } from 'ember-page-title';
import { LinkTo } from '@ember/routing';
import styles from './styles.css';

import { Route } from 'ember-polaris-routing';
import CompatRoute from 'ember-polaris-routing/route/compat';

export class ChoreographyRootRoute extends Route<{}> {
  <template>
    {{pageTitle 'Choreographie'}}

    <header class={{styles.header}}>
      <h1>Choreographie</h1>

      <nav>
        <ul>
          <li><LinkTo @route="choreography">Übersicht</LinkTo></li>
          <li><LinkTo @route="choreography.unidance-writing">UniDance Writing</LinkTo></li>
          <li><LinkTo @route="choreography.not-todo-list">Not Todo Liste</LinkTo></li>
        </ul>
      </nav>
    </header>

    {{outlet}}
  </template>
}

export default CompatRoute(ChoreographyRootRoute);
