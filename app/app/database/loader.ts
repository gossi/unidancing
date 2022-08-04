import exercisesDb from '@unidancing/database/exercises.json';
import skillsDb from '@unidancing/database/skills.json';
import { Exercise } from './exercises';
import { Skill } from './skills';
import DataService, { Databases } from '../services/data';

export function load(service: DataService): Databases {
  const skills = Object.values(skillsDb.data).map(
    (skill) => new Skill(service, skill)
  );

  const exercises = Object.values(exercisesDb.data).map(
    (exercise) => new Exercise(service, exercise)
  );

  return {
    exercises,
    skills
  };
}
