import { resource, resourceFactory } from 'ember-resources';
import { sweetenOwner } from 'ember-sweet-owner';

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import { client } from '../../supporting/tina';
import { cacheResult } from '../../supporting/utils';

import type { Art } from './-types';
import type { ArtConnectionEdges } from '@/tina/types';
import type { LinkManagerService } from 'ember-link';

export const findArts = resourceFactory(() => {
  return resource(async ({ owner }): Promise<Art[]> => {
    return cacheResult('arts', owner, async () => {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
      const artsResponse = await client.queries.artConnection({ sort: 'title' });

      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      return (artsResponse.data.artConnection.edges as ArtConnectionEdges[] | undefined)?.map(
        (edge) => edge.node
      ) as Art[];
    });
  });
});

export const findArt = resourceFactory((id: string) => {
  return resource(async ({ owner }): Promise<Art> => {
    return cacheResult(`art-${id}`, owner, async () => {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
      const artResponse = await client.queries.art({ relativePath: `${id}.md` });

      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      return artResponse.data.art as Art;
    });
  });
});

export const buildArtLink = resourceFactory((art: string) => {
  return resource(({ owner }) => {
    const { services } = sweetenOwner(owner);
    const { linkManager } = services;

    return (linkManager as LinkManagerService).createLink({
      route: 'arts.details',
      models: [art]
    });
  });
});
