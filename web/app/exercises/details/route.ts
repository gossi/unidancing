import Route from '@ember/routing/route';
import { service } from '@ember/service';

import { createSkillLinkBuilder } from '../../skills/resource';
import { createExerciseLinkBuilder, useExercise } from '../resource';

import type { Games } from '../../games/games';
import type { Registry as Services } from '@ember/service';

export default class ExerciseDetailsRoute extends Route {
  @service declare linkManager: Services['link-manager'];
  @service declare router: Services['router'];

  resource = useExercise(this);

  model({ id }: { id: string }) {
    return {
      exercise: this.resource.find(id),
      buildExerciseLink: createExerciseLinkBuilder(this.linkManager),
      buildSkillLink: createSkillLinkBuilder(this.linkManager),
      buildGameLink: this.buildGameLink
    };
  }

  buildGameLink = <K extends keyof Games>(game: K, params?: Games[K]) => {
    return this.linkManager.createLink({
      route: this.router.currentRouteName as string,
      query: {
        game,
        ...params
      }
    });
  };
}
