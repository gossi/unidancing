import RouteTemplate from 'ember-route-template';
import pageTitle from 'ember-page-title/helpers/page-title';
import { LinkTo } from '@ember/routing';
import styles from './styles.css';

export default RouteTemplate(<template>
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

</template>);
