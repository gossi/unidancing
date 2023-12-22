import { resource, resourceFactory } from 'ember-resources';
import { sweetenOwner } from 'ember-sweet-owner';

import type { Exercise } from '.';
import type { LinkManagerService } from 'ember-link';

export const findExercises = resourceFactory(() => {
  return resource(async ({ owner }): Promise<Exercise[]> => {
    const { services } = sweetenOwner(owner);
    const { tina } = services;

    const exercisesResponse = await tina.client.queries.exerciseConnection();

    return exercisesResponse.data.exerciseConnection.edges?.map((ex) => ex?.node) as Exercise[];
  });
});

export const findExercise = resourceFactory((id: string) => {
  return resource(async ({ owner }): Promise<Exercise> => {
    const { services } = sweetenOwner(owner);
    const { tina } = services;

    const ex = await tina.client.queries.exercise({ relativePath: `${id}.md` });

    return ex.data.exercise as Exercise;
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
