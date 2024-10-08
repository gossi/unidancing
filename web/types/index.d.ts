import 'ember-source/types';
import 'ember-source/types/preview';
import 'matomo-js-client-types';

import type Service from 'ember-polaris-service';
import type { Scope, ServiceFactory } from 'ember-polaris-service';

declare module 'ember-sweet-owner' {
  type ServiceConstructor<T> = typeof Service & ServiceFactory<T> & { new (scope: Scope): T };

  export interface SweetOwner {
    service<S extends ServiceConstructor<unknown>>(this: void, factory: S): InstanceType<S>;
  }
}
