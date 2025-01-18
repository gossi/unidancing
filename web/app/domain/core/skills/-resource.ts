import { resource, resourceFactory } from 'ember-resources';
import { sweetenOwner } from 'ember-sweet-owner';

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import { client } from '../../supporting/tina';
import { cacheResult } from '../../supporting/utils';

import type { Skill } from './-types';
import type { SkillConnectionEdges } from '@/tina/types';
import type { LinkManagerService } from 'ember-link';

export const findSkills = resourceFactory(() => {
  return resource(async ({ owner }): Promise<Skill[]> => {
    return cacheResult('skills', owner, async () => {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
      const skillsResponse = await client.queries.skillConnection();

      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      return (skillsResponse.data.skillConnection.edges as SkillConnectionEdges[] | undefined)?.map(
        (ex) => ex.node
      ) as Skill[];
    });
  });
});

export const findSkill = resourceFactory((id: string) => {
  return resource(async ({ owner }): Promise<Skill> => {
    return cacheResult(`skill-${id}`, owner, async () => {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
      const skill = await client.queries.skill({ relativePath: `${id}.md` });

      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
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
