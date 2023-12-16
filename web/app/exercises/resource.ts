import { service } from '@ember/service';

import { Resource } from 'ember-resources';

import type TinaService from '../services/tina';
import type { Registry as Services } from '@ember/service';
import type { Link } from 'ember-link';

export function createExerciseLinkBuilder(
  linkManager: Services['link-manager']
): (exercise: string) => Link {
  return (exercise: string): Link => {
    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    // @ts-ignore
    return linkManager.createLink({
      route: 'exercises.details',
      models: [exercise]
    });
  };
}

export class ExerciseResource extends Resource {
  @service declare data: Services['data'];
  @service declare tina: TinaService;

  get exercises() {
    return this.data.find('exercises');
  }

  async findAll() {
    const exercisesResponse = await this.tina.client.queries.exercisesConnection();

    const exercises = exercisesResponse.data.exercisesConnection.edges?.map((ex) => {
      return { slug: ex?.node?._sys.filename };
    });

    console.log(exercises);
  }

  async find(id: string) {
    const ex = await this.tina.client.queries.exercises({ relativePath: `${id}.md` });

    console.log(ex);

    return this.data.findOne('exercises', id);
  }
}

export function useExercise(destroyable: object) {
  return ExerciseResource.from(destroyable);
}
