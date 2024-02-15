/* eslint-disable no-unused-vars */
import Evented from '@ember/object/evented';
import Service from '@ember/service';

import type Transition from '@ember/routing/-private/transition';

interface Data {
  authenticated: Record<string, unknown> & {
    id: string;
  };
}

class Session extends Service.extend(Evented) {
  /**
   * Triggered whenever the session is successfully authenticated. This happens
   * when the session gets authenticated via
   * {{#crossLink "SessionService/authenticate:method"}}{{/crossLink}} but also
   * when the session is authenticated in another tab or window of the same
   * application and the session state gets synchronized across tabs or windows
   * via the store (see
   * {{#crossLink "BaseStore/sessionDataUpdated:event"}}{{/crossLink}}).
   * When using the {{#crossLink "ApplicationRouteMixin"}}{{/crossLink}} this
   * event will automatically get handled (see
   * {{#crossLink "ApplicationRouteMixin/sessionAuthenticated:method"}}{{/crossLink}}).
   * @event authenticationSucceeded
   * @public
   */

  /**
   * Triggered whenever the session is successfully invalidated. This happens
   * when the session gets invalidated via
   * {{#crossLink "SessionService/invalidate:method"}}{{/crossLink}} but also
   * when the session is invalidated in another tab or window of the same
   * application and the session state gets synchronized across tabs or windows
   * via the store (see
   * {{#crossLink "BaseStore/sessionDataUpdated:event"}}{{/crossLink}}).
   * When using the {{#crossLink "ApplicationRouteMixin"}}{{/crossLink}} this
   * event will automatically get handled (see
   * {{#crossLink "ApplicationRouteMixin/sessionInvalidated:method"}}{{/crossLink}}).
   * @event invalidationSucceeded
   * @public
   */

  isAuthenticated: boolean;
  data: Data | null;
  store: unknown;
  attemptedTransition: unknown;
  session: unknown;

  setup(): Promise<void>;

  set(key: string, value: unknown): unknown;
  authenticate(...args: unknown[]): Promise<unknown>;
  invalidate(...args: unknown): Promise<unknown>;
  authorize(...args: unknown[]): Promise<unknown>;

  requireAuthentication(transition: Transition, routeOrCallback: string | (() => void)): boolean;

  prohibitAuthentication(routeOrCallback: string | (() => void)): boolean;

  handleAuthentication(routeAfterAuthentication: string): void;
  handleInvalidation(routeAfterInvalidation: string): void;
}

declare module 'ember-simple-auth/services/session' {
  export = Session;
}

declare module '@ember/service' {
  interface Registry {
    session: Session;
  }
}
