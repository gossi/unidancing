import exercisesDb from '@unidancing/database/exercises.json';
import skillsDb from '@unidancing/database/skills.json';
import principlesDb from '@unidancing/database/principles.json';
import movesDb from '@unidancing/database/moves.json';
import { Exercise } from './exercises';
import { Skill } from './skills';
import { Principle } from './principles';
import { Move } from './moves';
import DataService, { Databases } from '../services/data';

export function load(service: DataService): Databases {
  const skills = Object.values(skillsDb.data).map(
    (skill) => new Skill(service, skill)
  );

  const exercises = Object.values(exercisesDb.data).map(
    (exercise) => new Exercise(service, exercise)
  );

  const principles = Object.values(principlesDb.data).map(
    (principle) => new Principle(service, principle)
  );

  const moves = Object.values(movesDb.data).map(
    (move) => new Move(service, move)
  );

  return {
    exercises,
    skills,
    principles,
    moves
  };
}
