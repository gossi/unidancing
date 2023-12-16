import Route from '@ember/routing/route';

import { useExercise } from '../resource';

export default class ExerciseIndexRoute extends Route {
  resource = useExercise(this);

  async model() {
    await this.resource.findAll();

    return this.resource.exercises;
  }
}
