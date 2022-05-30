/* eslint-disable no-unused-vars */
import Evented from '@ember/object/evented';
import Transition from '@ember/routing/-private/transition';
import Service from '@ember/service';

interface Data {
  authenticated: Record<string, unknown> & {
    id: string;
  };
}

// @ts-ignore
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
  store: any;
  attemptedTransition: any;
  session: any;

  setup(): Promise<void>;

  // @ts-ignore
  set(key: string, value: any): any;
  authenticate(...args: any[]): Promise<unknown>;
  invalidate(...args: any): Promise<unknown>;
  authorize(...args: any[]): Promise<unknown>;

  requireAuthentication(
    transition: Transition,
    routeOrCallback: string | (() => void)
  ): boolean;

  prohibitAuthentication(routeOrCallback: string | (() => void)): boolean;

  handleAuthentication(routeAfterAuthentication: string): void;
  handleInvalidation(routeAfterInvalidation: string): void;
}

declare module 'ember-simple-auth/services/session' {
  // @ts-ignore
  export = Session;
}

declare module '@ember/service' {
  interface Registry {
    session: Session;
  }
}
