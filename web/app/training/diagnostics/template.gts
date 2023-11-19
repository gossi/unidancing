import RouteTemplate from 'ember-route-template';
import { pageTitle } from 'ember-page-title';

export default RouteTemplate(<template>
  {{pageTitle "Diagnostik"}}

  {{outlet}}
</template>);
