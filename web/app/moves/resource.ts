import { resource, resourceFactory } from 'ember-resources';
import { sweetenOwner } from 'ember-sweet-owner';

import { cacheResult } from '../utils/data';

import type { Move } from '.';
import type { LinkManagerService } from 'ember-link';

export const findMoves = resourceFactory(() => {
  return resource(async ({ owner }): Promise<Move[]> => {
    const { services } = sweetenOwner(owner);
    const { tina } = services;

    return cacheResult('moves', owner, async () => {
      const movesResponse = await tina.client.queries.moveConnection();

      return movesResponse.data.moveConnection.edges?.map((ex) => ex?.node) as Move[];
    });
  });
});

export const findMove = resourceFactory((id: string) => {
  return resource(async ({ owner }): Promise<Move> => {
    const { services } = sweetenOwner(owner);
    const { tina } = services;

    return cacheResult(`move-${id}`, owner, async () => {
      const ex = await tina.client.queries.move({ relativePath: `${id}.md` });

      return ex.data.move as Move;
    });
  });
});

export const buildMoveLink = resourceFactory((move: string) => {
  return resource(({ owner }) => {
    const { services } = sweetenOwner(owner);
    const { linkManager } = services;

    return (linkManager as LinkManagerService).createLink({
      route: 'moves.details',
      models: [move]
    });
  });
});
