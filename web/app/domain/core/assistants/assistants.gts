import { DanceMix, DanceMixParam } from './dance-mix/dance-mix';
import { Looper } from './looper/looper';

import type { DanceMixParams } from './dance-mix/dance-mix';

export enum Assistant {
  // eslint-disable-next-line @typescript-eslint/no-shadow
  DanceMix = 'dance-mix',
  // eslint-disable-next-line @typescript-eslint/no-shadow
  Looper = 'looper'
}

export interface AssistantParams {
  [Assistant.DanceMix]: DanceMixParams;
}

export type AllAssistantParams = DanceMixParams;

export const ALL_ASSISTANT_PARAMS = [...Object.values(DanceMixParam)];

export function findAssistant(assistant?: Assistant) {
  switch (assistant) {
    case Assistant.DanceMix:
      return DanceMix;

    case Assistant.Looper:
      return Looper;
  }

  return undefined;
}
