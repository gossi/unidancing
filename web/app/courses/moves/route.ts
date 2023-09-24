import Route from '@ember/routing/route';
import { MoveResource } from '../../moves/resource';
import { ExerciseResource } from '../../exercises/resource';

export default class MoveIndexRoute extends Route {
  moves = MoveResource.from(this);
  exercises = ExerciseResource.from(this);

  lesson1 = {
    moves: [
      'chest-roll',
      'circular-chest-roll',
      'around-the-head',
      'no-no-soft-hands',
      'pointing'
    ].map((move) => this.moves.find(move))
  };

  lesson4 = {
    exercises: ['tutting-introduction', 'uni-orchestra'].map((ex) =>
      this.exercises.find(ex)
    )
  };

  lesson5 = {
    exercises: ['locking-introduction'].map((ex) => this.exercises.find(ex))
  };

  model() {
    return {
      lesson1: this.lesson1,
      lesson4: this.lesson4,
      lesson5: this.lesson5
    };
  }
}
