import Route from '@ember/routing/route';

import { CoursesResource } from '../resource';

export default class ExerciseIndexRoute extends Route {
  resource = CoursesResource.from(this);

  model() {
    return this.resource.courses;
  }
}
