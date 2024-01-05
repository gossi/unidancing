import { resource, resourceFactory } from 'ember-resources';
import { sweetenOwner } from 'ember-sweet-owner';

import { cacheResult } from '../utils/data';

import type { Awfulpractice, Tag } from '.';
import type { AwfulpracticeConnectionQueryVariables } from '@/tina/types';

export const findAwfulPractices = resourceFactory((tag?: Tag) => {
  return resource(async ({ owner }): Promise<Awfulpractice[]> => {
    const { services } = sweetenOwner(owner);
    const { tina } = services;

    const options: AwfulpracticeConnectionQueryVariables = {
      sort: 'title'
    };

    const practices = await cacheResult('awful-practices', owner, async () => {
      const apResponse = await tina.client.queries.awfulpracticeConnection(options);

      return apResponse.data.awfulpracticeConnection.edges?.map(
        (ap) => ap?.node
      ) as Awfulpractice[];
    });

    if (tag) {
      return practices.filter((practice) => practice.tags?.includes(tag));
    }

    return practices;
  });
});
