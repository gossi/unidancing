import { resource, resourceFactory } from 'ember-resources';
import { sweetenOwner } from 'ember-sweet-owner';

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import { client } from '../../supporting/tina';
import { cacheResult } from '../../supporting/utils';

import type { Exercise } from './domain-objects';
import type { ExerciseConnectionEdges as Edges } from '@/tina/types';
import type { LinkManagerService } from 'ember-link';

export const findExercises = resourceFactory(() => {
  return resource(async ({ owner }): Promise<Exercise[]> => {
    return cacheResult('exercises', owner, async () => {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
      const exercisesResponse = await client.queries.exerciseConnection();

      return (
        // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
        (exercisesResponse.data.exerciseConnection.edges as Edges[] | undefined)?.map(
          (ex) => ex.node
        ) as Exercise[]
      );
    });
  });
});

export const findExercise = resourceFactory((id: string) => {
  return resource(async ({ owner }): Promise<Exercise> => {
    return cacheResult(`exercise-${id}`, owner, async () => {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment, @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access
      const ex = await client.queries.exercise({ relativePath: `${id}.md` });

      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access
      return ex.data.exercise as Exercise;
    });
  });
});

export const buildExerciseLink = resourceFactory((exercise: string) => {
  return resource(({ owner }) => {
    const { services } = sweetenOwner(owner);
    const { linkManager } = services;

    return (linkManager as LinkManagerService).createLink({
      route: 'exercises.details',
      models: [exercise]
    });
  });
});
