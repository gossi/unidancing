import Route from '@ember/routing/route';
import { service, Registry as Services } from '@ember/service';
import { useExercise, createExerciseLinkBuilder } from '../resource';
import { createSkillLinkBuilder } from '../../skills/resource';

export default class ExerciseDetailsRoute extends Route {
  @service declare linkManager: Services['link-manager'];

  resource = useExercise(this);

  model({ id }: { id: string }) {
    return {
      exercise: this.resource.find(id),
      buildExerciseLink: createExerciseLinkBuilder(this.linkManager),
      buildSkillLink: createSkillLinkBuilder(this.linkManager)
    };
  }
}
