import { resource, resourceFactory } from 'ember-resources';
import { sweetenOwner } from 'ember-sweet-owner';

// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import { client } from '../../supporting/tina';
import { cacheResult } from '../../supporting/utils';

import type { Exercise } from './domain-objects';
import type { LinkManagerService } from 'ember-link';

export const findExercises = resourceFactory(() => {
  return resource(async ({ owner }): Promise<Exercise[]> => {
    return cacheResult('exercises', owner, async () => {
      const exercisesResponse = await client.queries.exerciseConnection();

      return exercisesResponse.data.exerciseConnection.edges?.map((ex) => ex?.node) as Exercise[];
    });
  });
});

export const findExercise = resourceFactory((id: string) => {
  return resource(async ({ owner }): Promise<Exercise> => {
    return cacheResult(`exercise-${id}`, owner, async () => {
      const ex = await client.queries.exercise({ relativePath: `${id}.md` });

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
