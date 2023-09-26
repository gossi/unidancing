import RouteTemplate from 'ember-route-template';
import pageTitle from 'ember-page-title/helpers/page-title';
import { link } from 'ember-link';
import styles from './styles.css';
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
  {{pageTitle 'Emotionen'}}

  <h1>Emotionen</h1>

  <h2>Kursinhalte</h2>

  <ul>
    <li></li>
  </ul>

  <h2>Trainingseinheiten</h2>

  <h3>Einheit 1</h3>

  <div class={{styles.units}}>
    {{#each @model.lesson1.exercises as |ex|}}
      <Exercise
        @exercise={{ex}}
        @link={{link 'exercises.details' ex.id}}
      />
    {{/each}}
  </div>

  <h3>Einheit 2</h3>

  <div class={{styles.units}}>
    {{#each @model.lesson2.exercises as |ex|}}
      <Exercise
        @exercise={{ex}}
        @link={{link 'exercises.details' ex.id}}
      />
    {{/each}}
  </div>

  <h3>Einheit 3</h3>

  <div class={{styles.units}}>
    {{#each @model.lesson3.exercises as |ex|}}
      <Exercise
        @exercise={{ex}}
        @link={{link 'exercises.details' ex.id}}
      />
    {{/each}}
  </div>

  <h3>Einheit 4</h3>

  <div class={{styles.units}}>
    {{#each @model.lesson4.exercises as |ex|}}
      <Exercise
        @exercise={{ex}}
        @link={{link 'exercises.details' ex.id}}
      />
    {{/each}}
  </div>

  <h3>Einheit 5</h3>

  <div class={{styles.units}}>
    {{#each @model.lesson5.exercises as |ex|}}
      <Exercise
        @exercise={{ex}}
        @link={{link 'exercises.details' ex.id}}
      />
    {{/each}}
  </div>
</template>);
