import Route from '@ember/routing/route';
import { service, Registry as Services } from '@ember/service';
import { useExercise, createExerciseLinkBuilder } from '../resource';
import { createSkillLinkBuilder } from '../../skills/resource';
import { Games } from '../../games/games';

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
    return this.linkManager.createUILink({
      route: this.router.currentRouteName,
      query: {
        game,
        ...params
      }
    });
  };
}
