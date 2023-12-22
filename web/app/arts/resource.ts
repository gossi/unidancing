import { resource, resourceFactory } from 'ember-resources';
import { sweetenOwner } from 'ember-sweet-owner';

import type { Art } from '.';
import type { LinkManagerService } from 'ember-link';

export const findArts = resourceFactory(() => {
  return resource(async ({ owner }): Promise<Art[]> => {
    const { services } = sweetenOwner(owner);
    const { tina } = services;

    const artsResponse = await tina.client.queries.artConnection({ sort: 'title' });

    return artsResponse.data.artConnection.edges?.map((art) => art?.node) as Art[];
  });
});

export const findArt = resourceFactory((id: string) => {
  return resource(async ({ owner }): Promise<Art> => {
    const { services } = sweetenOwner(owner);
    const { tina } = services;

    const artResponse = await tina.client.queries.art({ relativePath: `${id}.md` });

    // tina.client.queries.techniqueConnection({ filter: });

    return artResponse.data.art as Art;
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
