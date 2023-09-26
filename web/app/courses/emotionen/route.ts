import Route from '@ember/routing/route';

import { ExerciseResource } from '../../exercises/resource';

import type { Exercise } from '../../database/exercises';

export interface Lesson {
  exercises: Exercise[];
}

export default class MoveIndexRoute extends Route {
  exercises = ExerciseResource.from(this);

  lesson1: Lesson = {
    exercises: ['steinmetz', 'pantotion'].map((ex) => this.exercises.find(ex) as Exercise)
  };

  lesson2: Lesson = {
    exercises: ['emoretro'].map((ex) => this.exercises.find(ex) as Exercise)
  };

  lesson3: Lesson = {
    exercises: ['emopost'].map((ex) => this.exercises.find(ex) as Exercise)
  };

  lesson4: Lesson = {
    exercises: ['gruppenemotionen'].map((ex) => this.exercises.find(ex) as Exercise)
  };

  lesson5: Lesson = {
    exercises: ['mood-impro'].map((ex) => this.exercises.find(ex) as Exercise)
  };

  model() {
    return {
      lesson1: this.lesson1,
      lesson2: this.lesson2,
      lesson3: this.lesson3,
      lesson4: this.lesson4,
      lesson5: this.lesson5
    };
  }
}
