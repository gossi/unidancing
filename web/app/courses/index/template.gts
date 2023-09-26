import RouteTemplate from 'ember-route-template';
import pageTitle from 'ember-page-title/helpers/page-title';
import { LinkTo } from '@ember/routing';

export default RouteTemplate(<template>
  {{pageTitle 'Kurse'}}
  <h1>Kurse</h1>

  <article>
    <header><LinkTo @route='courses.moves'>Moves</LinkTo></header>
    <p>Zur Steigerung des Bewegungsrepertoires von Easy, Beginner Moves zu
    Intermediate Moves in einem breiten Spektrum</p>
  </article>

  <article>
    <header><LinkTo @route='courses.emotionen'>Emotionen</LinkTo></header>
    <p>Emotionen verstehen und ausdrücken.</p>
  </article>

  <article>
    <header><LinkTo @route='courses.improvisation'>Improvisation</LinkTo></header>
    <p>Frei erfundene Bewegungen zur Musik, mit und ohne Partner.</p>
  </article>
</template>);
