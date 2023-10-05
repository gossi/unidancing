import coursesDb from '@unidancing/database/courses.json';
import exercisesDb from '@unidancing/database/exercises.json';
import movesDb from '@unidancing/database/moves.json';
import principlesDb from '@unidancing/database/principles.json';
import skillsDb from '@unidancing/database/skills.json';

import { Course } from './courses';
import { Exercise } from './exercises';
import { Move } from './moves';
import { Principle } from './principles';
import { Skill } from './skills';

import type { Databases } from '../services/data';
import type DataService from '../services/data';

export function load(service: DataService): Databases {
  const skills = Object.values(skillsDb.data).map((skill) => new Skill(service, skill));

  const exercises = Object.values(exercisesDb.data).map(
    (exercise) => new Exercise(service, exercise)
  );

  const principles = Object.values(principlesDb.data).map(
    (principle) => new Principle(service, principle)
  );

  const moves = Object.values(movesDb.data).map((move) => new Move(service, move));

  const courses = Object.values(coursesDb.data).map((move) => new Course(service, move));

  return {
    exercises,
    skills,
    principles,
    moves,
    courses
  };
}
