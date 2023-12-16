import Route from '@ember/routing/route';
import { service } from '@ember/service';

import { createSkillLinkBuilder } from '../../skills/resource';
import { createExerciseLinkBuilder, useExercise } from '../resource';

import type { Games } from '../../games/games';
import type RouterService from '@ember/routing/router-service';
import type { Link, LinkManagerService } from 'ember-link';

export type GameLinkBuilder<K extends keyof Games> = (game: K, params?: Games[K]) => Link;

export function createGameLinkBuilder<K extends keyof Games>(
  linkManager: LinkManagerService,
  router: RouterService
): GameLinkBuilder<K> {
  return (game: K, params?: Games[K]): Link => {
    return linkManager.createLink({
      route: router.currentRouteName as string,
      query: {
        game,
        ...params
      }
    });
  };
}

export default class ExerciseDetailsRoute extends Route {
  @service declare linkManager: LinkManagerService;
  @service declare router: RouterService;

  resource = useExercise(this);

  async model({ id }: { id: string }) {
    return {
      exercise: await this.resource.find(id),
      buildExerciseLink: createExerciseLinkBuilder(this.linkManager),
      buildSkillLink: createSkillLinkBuilder(this.linkManager),
      buildGameLink: createGameLinkBuilder(this.linkManager, this.router)
    };
  }
}
