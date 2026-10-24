import { resource, resourceFactory } from 'ember-resources';

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import { client } from '../../../../supporting/tina';
import { cacheResult } from '../../../../supporting/utils';

import type { RoutineResult } from './domain-objects';

export const findRoutines = resourceFactory(() => {
  return resource(async ({ owner }): Promise<RoutineResult[]> => {
    return cacheResult('routines', owner, async () => {
      const routineResponse = await client.queries.routinesConnection();

      return routineResponse.data.routinesConnection.edges?.map(
        // eslint-disable-next-line @typescript-eslint/ban-ts-comment
        // @ts-ignore

        (ex) => ex?.node
      ) as unknown as RoutineResult[];
    });
  });
});

export const findRoutine = resourceFactory((id: string) => {
  return resource(async ({ owner }): Promise<RoutineResult> => {
    return cacheResult(`routine-${id}`, owner, async () => {
      const routineResponse = await client.queries.routines({ relativePath: `${id}.json` });

      return routineResponse.data.routines as unknown as RoutineResult;
    });
  });
});
