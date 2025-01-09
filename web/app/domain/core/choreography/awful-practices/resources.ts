import { resource, resourceFactory } from 'ember-resources';

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore gts file
import { client } from '../../../supporting/tina';
import { cacheResult } from '../../../supporting/utils';

import type { Awfulpractice, Tag } from './domain';
import type { AwfulpracticeConnectionQueryVariables } from '@/tina/types';

export const findAwfulPractices = resourceFactory(
  (options: AwfulpracticeConnectionQueryVariables = {}) => {
    return resource(async ({ owner }): Promise<Awfulpractice[]> => {
      const vars: AwfulpracticeConnectionQueryVariables = {
        first: 100,
        sort: 'title',
        ...options
      };

      const practices = await cacheResult('awful-practices', owner, async () => {
        const apResponse = await client.queries.awfulpracticeConnection(vars);

        return apResponse.data.awfulpracticeConnection.edges?.map(
          // eslint-disable-next-line @typescript-eslint/ban-ts-comment
          // @ts-ignore gts file
          (ap) => ap?.node
        ) as Awfulpractice[];
      });

      return practices;
    });
  }
);

export function filterByTag(practices: Awfulpractice[], tag: Tag) {
  return practices.filter((practice) => practice.tags?.includes(tag));
}
