import { service } from '@ember/service';

import { Resource } from 'ember-resources';

import type { Registry as Services } from '@ember/service';
import type { Link } from 'ember-link';

export function createCourseLinkBuilder(
  linkManager: Services['link-manager']
): (exercise: string) => Link {
  return (exercise: string): Link => {
    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    // @ts-ignore
    return linkManager.createLink({
      route: 'courses.details',
      models: [exercise]
    });
  };
}

export class CoursesResource extends Resource {
  @service declare data: Services['data'];

  get courses() {
    return this.data.find('courses');
  }

  find(id: string) {
    return this.data.findOne('courses', id);
  }
}
