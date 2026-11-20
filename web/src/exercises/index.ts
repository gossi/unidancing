import { buildRegistry } from 'ember-strict-application-resolver/build-registry';

import { buildRoutes } from '#support/routing';

import DetailsRoute from './-routes/details';
import IndexRoute from './-routes/index';
import RootRoute from './-routes/root';

export { ExerciseTeaser } from './-components';
export { buildExerciseLink } from './-resource';
export type {
  Difficulty,
  Exercise,
  ExerciseInstructionMedia,
  ExerciseMedia,
  ExerciseMediaDancemix,
  ExerciseMediaLoop,
  ExerciseMediaMaterial,
  ExerciseMediaSong,
  Instruction,
  Locomotion,
  Personal
} from './domain-objects';
export {
  asDifficulty,
  asLocomotion,
  asMedia,
  asMediaCollection,
  asPersonal,
  isDanceMix,
  isLoop,
  isMaterial,
  isSong
} from './domain-objects';

/**
 * @internal
 */
export const ExercisesManifest = {
  buildRegistry: buildRegistry({
    './routes/exercises': RootRoute,
    './routes/exercises/index': IndexRoute,
    './routes/exercises/details': DetailsRoute
  }),
  buildRoutes: buildRoutes(function () {
    /* eslint-disable @typescript-eslint/no-invalid-this, unicorn/no-this-outside-of-class */
    this.route('exercises', { path: 'uebungen' }, function () {
      this.route('details', { path: '/:id' });
    });
    /* eslint-enable @typescript-eslint/no-invalid-this, unicorn/no-this-outside-of-class */
  })
};
