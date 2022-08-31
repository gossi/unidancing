import { Resource } from 'ember-resources';
import { service, Registry as Services } from '@ember/service';
import { Link } from 'ember-link';

export function createExerciseLinkBuilder(
  linkManager: Services['link-manager']
): (exercise: string) => Link {
  return (exercise: string): Link => {
    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    // @ts-ignore
    return linkManager.createUILink({
      route: 'exercises.details',
      models: [exercise]
    });
  };
}

export class ExerciseResource extends Resource {
  @service declare data: Services['data'];

  get exercises() {
    return this.data.find('exercises');
  }

  find(id: string) {
    return this.data.findOne('exercises', id);
  }
}

export function useExercise(destroyable: object) {
  return ExerciseResource.from(destroyable);
}
