import { resource, resourceFactory } from 'ember-resources';
import { sweetenOwner } from 'ember-sweet-owner';

import { cacheResult } from '../utils/data';

import type { Skill } from '.';
import type { LinkManagerService } from 'ember-link';

export const findSkills = resourceFactory(() => {
  return resource(async ({ owner }): Promise<Skill[]> => {
    const { services } = sweetenOwner(owner);
    const { tina } = services;

    return cacheResult('skills', owner, async () => {
      const skillsResponse = await tina.client.queries.skillConnection();

      return skillsResponse.data.skillConnection.edges?.map((ex) => ex?.node) as Skill[];
    });
  });
});

export const findSkill = resourceFactory((id: string) => {
  return resource(async ({ owner }): Promise<Skill> => {
    const { services } = sweetenOwner(owner);
    const { tina } = services;

    return cacheResult(`skill-${id}`, owner, async () => {
      const skill = await tina.client.queries.skill({ relativePath: `${id}.md` });

      return skill.data.skill as Skill;
    });
  });
});

export const buildSkillLink = resourceFactory((skill: string) => {
  return resource(({ owner }) => {
    const { services } = sweetenOwner(owner);
    const { linkManager } = services;

    return (linkManager as LinkManagerService).createLink({
      route: 'skills.details',
      models: [skill]
    });
  });
});
