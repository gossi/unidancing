import RouteTemplate from 'ember-route-template';
import pageTitle from 'ember-page-title/helpers/page-title';
import Listing from '../-components/listing';

export default RouteTemplate(<template>
  {{pageTitle 'Not Todo Liste'}}

  <h2>Not Todo Liste</h2>

  <p>
    Über die Jahre haben sich
    <i>Dinge</i>
    angehäuft, die sich als eher
    <b>problematisch</b>
    für eine
    <i>ansprechende</i>
    Kür gezeigt haben. Die sind hier gelistet, so können zukünftige Generationen aus den Fehlern der
    vorigen Lernen.
  </p>

  <Listing />
</template>);
