import { client } from '@unidancing/tina';
import { cacheResult } from '@unidancing/utils';
import { resource, resourceFactory } from 'ember-resources';
import { sweetenOwner } from 'ember-sweet-owner';

import type { Skill } from './-types';
import type { LinkManagerService } from 'ember-link';

export const findSkills = resourceFactory(() => {
  return resource(async ({ owner }): Promise<Skill[]> => {
    return cacheResult('skills', owner, async () => {
      const skillsResponse = await client.queries.skillConnection();

      return skillsResponse.data.skillConnection.edges?.map((ex) => ex?.node) as Skill[];
    });
  });
});

export const findSkill = resourceFactory((id: string) => {
  return resource(async ({ owner }): Promise<Skill> => {
    return cacheResult(`skill-${id}`, owner, async () => {
      const skill = await client.queries.skill({ relativePath: `${id}.md` });

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
