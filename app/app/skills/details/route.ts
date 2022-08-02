import Route from '@ember/routing/route';
import { useSkill } from '../resource';

export default class SkillDetailsRoute extends Route {
  resource = useSkill(this);

  model({ id }: { id: string }) {
    return this.resource.find(id);
  }
}
