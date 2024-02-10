import { resource, resourceFactory } from 'ember-resources';
import { sweetenOwner } from 'ember-sweet-owner';

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import { client } from '../../supporting/tina';
import { cacheResult } from '../../supporting/utils';

import type { Move } from './-types';
import type { LinkManagerService } from 'ember-link';

export const findMoves = resourceFactory(() => {
  return resource(async ({ owner }): Promise<Move[]> => {
    return cacheResult('moves', owner, async () => {
      const movesResponse = await client.queries.moveConnection();

      return movesResponse.data.moveConnection.edges?.map((ex) => ex?.node) as Move[];
    });
  });
});

export const findMove = resourceFactory((id: string) => {
  return resource(async ({ owner }): Promise<Move> => {
    return cacheResult(`move-${id}`, owner, async () => {
      const ex = await client.queries.move({ relativePath: `${id}.md` });

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
