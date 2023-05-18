import { Resource } from 'ember-resources';
import { service, Registry as Services } from '@ember/service';
import { Link } from 'ember-link';

export function createMoveLinkBuilder(
  linkManager: Services['link-manager']
): (move: string) => Link {
  return (move: string): Link => {
    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    // @ts-ignore
    return linkManager.createUILink({
      route: 'moves.details',
      models: [move]
    });
  };
}

export class MoveResource extends Resource {
  @service declare data: Services['data'];

  get moves() {
    return this.data.find('moves');
  }

  find(id: string) {
    return this.data.findOne('moves', id);
  }
}

// export function useExercise(destroyable: object) {
//   return MoveResource.from(destroyable);
// }
