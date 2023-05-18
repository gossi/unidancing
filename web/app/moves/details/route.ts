import Route from '@ember/routing/route';
import { service, Registry as Services } from '@ember/service';
import { MoveResource, createMoveLinkBuilder } from '../resource';
import { createSkillLinkBuilder } from '../../skills/resource';
import { Games } from '../../games/games';

export default class ExerciseDetailsRoute extends Route {
  @service declare linkManager: Services['link-manager'];
  @service declare router: Services['router'];

  resource = MoveResource.from(this);

  model({ id }: { id: string }) {
    return {
      move: this.resource.find(id),
      buildExerciseLink: createMoveLinkBuilder(this.linkManager),
      buildSkillLink: createSkillLinkBuilder(this.linkManager),
      buildGameLink: this.buildGameLink
    };
  }

  buildGameLink = <K extends keyof Games>(game: K, params?: Games[K]) => {
    return this.linkManager.createUILink({
      route: this.router.currentRouteName,
      query: {
        game,
        ...params
      }
    });
  };
}
