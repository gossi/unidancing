import RouteTemplate from 'ember-route-template';
import pageTitle from 'ember-page-title/helpers/page-title';
import { LinkTo } from '@ember/routing';
import styles from './styles.css';

export default RouteTemplate(<template>
  {{pageTitle 'Training'}}

  <header class={{styles.header}}>
    <h1>Training</h1>

    <nav>
      <ul>
        <li><LinkTo @route='training'>Übersicht</LinkTo></li>
        <li><LinkTo @route='training.control'>Steuerung</LinkTo></li>
        <li><LinkTo @route='training.diagnostics'>Diagnostik</LinkTo></li>
      </ul>
    </nav>
  </header>

  {{outlet}}
</template>);
