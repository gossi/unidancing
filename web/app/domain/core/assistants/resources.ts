import { resource, resourceFactory } from 'ember-resources';
import { sweetenOwner } from 'ember-sweet-owner';

import type { AssistantParams } from './assistants';
import type { LinkManagerService } from 'ember-link';

export const buildAssistantLink = resourceFactory(
  <P extends keyof AssistantParams>(assistant: P, params?: AssistantParams[P]) => {
    return resource(({ owner }) => {
      const { services } = sweetenOwner(owner);
      const { linkManager, router } = services;

      return (linkManager as LinkManagerService).createLink({
        route: router.currentRouteName as string,
        query: {
          assistant,
          ...params
        }
      });
    });
  }
);
