import RouteTemplate from 'ember-route-template';
import pageTitle from 'ember-page-title/helpers/page-title';
import { link } from 'ember-link';
import styles from './styles.css';
import Move from '../../moves/-components/teaser';
import Exercise from '../../exercises/-components/teaser';

import type { Lesson } from './route';

interface Signature {
  Args: {
    model: {
      lesson1: Lesson;
      lesson2: Lesson;
      lesson3: Lesson;
      lesson4: Lesson;
      lesson5: Lesson;
    }
  }
}

export default RouteTemplate<Signature>(<template>
  {{pageTitle 'Moves'}}

  <h1>Moves</h1>

  <h2>Kursinhalte</h2>

  <ul>
    <li>Steigerung des Bewegungsrepertoire</li>
    <li></li>
  </ul>

  <h2>Trainingseinheiten</h2>

  <h3>Einheit 1</h3>

  Einsteiger Moves

  <div class={{styles.units}}>
    {{#each @model.lesson1.moves as |move|}}
      <Move @move={{move}} @link={{link 'moves.details' move.id}} />
    {{/each}}
  </div>

  <h3>Einheit 4</h3>

  Übungen

  <div class={{styles.units}}>
    {{#each @model.lesson4.exercises as |ex|}}
      <Exercise
        @exercise={{ex}}
        @link={{link 'exercises.details' ex.id}}
      />
    {{/each}}
  </div>

  <h3>Einheit 5</h3>

  Übungen

  <div class={{styles.units}}>
    {{#each @model.lesson5.exercises as |ex|}}
      <Exercise
        @exercise={{ex}}
        @link={{link 'exercises.details' ex.id}}
      />
    {{/each}}
  </div>
</template>);
