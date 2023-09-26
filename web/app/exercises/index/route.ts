import Route from '@ember/routing/route';

import { useExercise } from '../resource';

export default class ExerciseIndexRoute extends Route {
  resource = useExercise(this);

  model() {
    return this.resource.exercises;
  }
}
