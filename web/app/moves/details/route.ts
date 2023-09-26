import Route from '@ember/routing/route';
import { service } from '@ember/service';

import { createSkillLinkBuilder } from '../../skills/resource';
import { createMoveLinkBuilder, MoveResource } from '../resource';

import type { Games } from '../../games/games';
import type RouterService from '@ember/routing/router-service';
import type { LinkManagerService } from 'ember-link';

export default class ExerciseDetailsRoute extends Route {
  @service declare linkManager: LinkManagerService;
  @service declare router: RouterService;

  resource = MoveResource.from(this, () => []);

  model({ id }: { id: string }) {
    return {
      move: this.resource.find(id),
      buildMoveLink: createMoveLinkBuilder(this.linkManager),
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
