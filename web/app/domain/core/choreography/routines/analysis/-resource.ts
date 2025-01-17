import { resource, resourceFactory } from 'ember-resources';

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import { client } from '../../../../supporting/tina';
import { cacheResult } from '../../../../supporting/utils';

import type { RoutineResult } from './domain-objects';

export const findRoutines = resourceFactory(() => {
  return resource(async ({ owner }): Promise<RoutineResult[]> => {
    return cacheResult('routines', owner, async () => {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
      const routineResponse = await client.queries.routinesConnection();

      // eslint-disable-next-line @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
      return routineResponse.data.routinesConnection.edges?.map(
        // eslint-disable-next-line @typescript-eslint/ban-ts-comment
        // @ts-ignore
        // eslint-disable-next-line @typescript-eslint/no-unsafe-return, @typescript-eslint/no-unsafe-member-access
        (ex) => ex?.node
      ) as unknown as RoutineResult[];
    });
  });
});

export const findRoutine = resourceFactory((id: string) => {
  return resource(async ({ owner }): Promise<RoutineResult> => {
    return cacheResult(`routine-${id}`, owner, async () => {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
      const routineResponse = await client.queries.routines({ relativePath: `${id}.json` });

      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      return routineResponse.data.routines as unknown as RoutineResult;
    });
  });
});
