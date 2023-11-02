import RouteTemplate from 'ember-route-template';
import { pageTitle } from 'ember-page-title';
import { LinkTo } from '@ember/routing';
import type { Course } from '../../database/courses';


interface Signature {
  Args: {
    model: Course[];
  }
}

export default RouteTemplate<Signature>(<template>
  {{pageTitle 'Kurse'}}
  <h1>Kurse</h1>

  {{#each @model as |course|}}
    <article>
      <header><LinkTo @route='courses.details' @model={{course.id}}>{{course.title}}</LinkTo></header>

      <p>Zur Steigerung des Bewegungsrepertoires von Easy, Beginner Moves zu
      Intermediate Moves in einem breiten Spektrum</p>
    </article>
  {{/each}}

  {{!-- <article>
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
  </article> --}}
</template>);
