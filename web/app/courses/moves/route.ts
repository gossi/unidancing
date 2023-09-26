import Route from '@ember/routing/route';

import { ExerciseResource } from '../../exercises/resource';
import { MoveResource } from '../../moves/resource';

import type { Exercise } from '../../database/exercises';
import type { Move } from '../../database/moves';

export interface Lesson {
  moves?: Move[];
  exercises?: Exercise[];
}

export default class MoveIndexRoute extends Route {
  moves = MoveResource.from(this);
  exercises = ExerciseResource.from(this);

  lesson1: Lesson = {
    moves: [
      'chest-roll',
      'circular-chest-roll',
      'around-the-head',
      'no-no-soft-hands',
      'pointing'
    ].map((move) => this.moves.find(move) as Move)
  };

  lesson4: Lesson = {
    exercises: ['tutting-introduction', 'uni-orchestra'].map(
      (ex) => this.exercises.find(ex) as Exercise
    )
  };

  lesson5: Lesson = {
    exercises: ['locking-introduction'].map((ex) => this.exercises.find(ex) as Exercise)
  };

  model() {
    return {
      lesson1: this.lesson1,
      lesson4: this.lesson4,
      lesson5: this.lesson5
    };
  }
}
