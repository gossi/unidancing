import Route from '@ember/routing/route';
import { service } from '@ember/service';

import { createExerciseLinkBuilder } from '../../exercises/resource';
import { CoursesResource } from '../resource';

import type RouterService from '@ember/routing/router-service';
import type { LinkManagerService } from 'ember-link';

export default class ExerciseDetailsRoute extends Route {
  @service declare linkManager: LinkManagerService;
  @service declare router: RouterService;

  resource = CoursesResource.from(this);

  model({ id }: { id: string }) {
    return {
      course: this.resource.find(id),
      buildExerciseLink: createExerciseLinkBuilder(this.linkManager)
    };
  }
}
