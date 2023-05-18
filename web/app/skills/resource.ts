import { Resource } from 'ember-resources';
import { service, Registry as Services } from '@ember/service';
import { Link } from 'ember-link';

export function createSkillLinkBuilder(
  linkManager: Services['link-manager']
): (skill: string) => Link {
  return (skill: string): Link => {
    return linkManager.createUILink({
      route: 'skills.details',
      models: [skill]
    });
  };
}

export class SkillResource extends Resource {
  @service declare data: Services['data'];

  get skills() {
    return this.data.find('skills');
  }

  find(id: string) {
    return this.data.findOne('skills', id);
  }
}

export function useSkill(destroyable: object) {
  return SkillResource.from(destroyable);
}
