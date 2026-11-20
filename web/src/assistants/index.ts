import { buildRegistry } from 'ember-strict-application-resolver/build-registry';

import { buildRoutes } from '#support/routing';

import { AssistantsRoute } from './routes/assistants';

export type { AllAssistantParams, AssistantParams } from './assistants';
export { ALL_ASSISTANT_PARAMS, Assistant } from './assistants';
export { AssistantFactory } from './components/assistant-factory';
export type { DanceMixParams } from './dance-mix/dance-mix';
export { DanceMixParam } from './dance-mix/dance-mix';
export type { Loops } from './looper/data';
export { data as looperData } from './looper/data';
export { Loop, Looper } from './looper/looper';
export { buildAssistantLink } from './resources';

/**
 * @internal
 */
export const AssistantsManifest = {
  buildRegistry: buildRegistry({
    './routes/assistants': AssistantsRoute
  }),
  buildRoutes: buildRoutes(function () {
    /* eslint-disable @typescript-eslint/no-invalid-this, unicorn/no-this-outside-of-class */
    this.route('assistants', { path: '/assistants/:assistant' });
    /* eslint-enable @typescript-eslint/no-invalid-this, unicorn/no-this-outside-of-class */
  })
};
