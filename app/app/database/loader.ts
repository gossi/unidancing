import exercisesDb, {
  Exercise,
  ExerciseWireFormat,
  Locomotion,
  Personal
} from './exercises';
import skillsDb, { Skill } from './skills';

export interface Databases {
  exercises: Exercise[];
  skills: Skill[];
}

function ensureArray<T>(stringOrArray: T | T[]): T[] {
  return Array.isArray(stringOrArray) ? stringOrArray : [stringOrArray];
}

function resolveExercises(exercises: ExerciseWireFormat[]) {
  return exercises.map((exercise) => {
    if (exercise.see) {
      exercise.see = exercise.see.map((see) => {
        if (typeof see === 'string') {
          return exercises.find((ex) => ex.id === see);
        }

        return see;
      });
    }

    if (exercise.personal) {
      exercise.personal = ensureArray<Personal>(exercise.personal);
    }

    if (exercise.locomotion) {
      exercise.locomotion = ensureArray<Locomotion>(exercise.locomotion);
    }

    return exercise;
  });
}

export function load(): Databases {
  const skills = Object.values(skillsDb);

  const exercises = resolveExercises(Object.values(exercisesDb)).map(
    (exercise) => {
      if (exercise.skills) {
        exercise.skills = exercise.skills.map((skillId) => {
          return skills.find((skill) => skill.id === skillId);
        });
      }

      return exercise;
    }
  );

  return {
    exercises,
    skills
  };
}
