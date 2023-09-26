import Route from '@ember/routing/route';

import { useSkill } from '../resource';

export default class SkillIndexRoute extends Route {
  resource = useSkill(this);

  model() {
    return this.resource.skills;
  }
}
