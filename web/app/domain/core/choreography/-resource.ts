import { resource, resourceFactory } from 'ember-resources';

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore gts file
import { client } from '../../supporting/tina';
import { cacheResult } from '../../supporting/utils';

import type { Awfulpractice, Tag } from './-types';
import type { AwfulpracticeConnectionQueryVariables } from '@/tina/types';

export const findAwfulPractices = resourceFactory((tag?: Tag) => {
  return resource(async ({ owner }): Promise<Awfulpractice[]> => {
    const options: AwfulpracticeConnectionQueryVariables = {
      sort: 'title'
    };

    const practices = await cacheResult('awful-practices', owner, async () => {
      const apResponse = await client.queries.awfulpracticeConnection(options);

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
