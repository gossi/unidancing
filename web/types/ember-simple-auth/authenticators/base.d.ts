/* eslint-disable no-unused-vars */
declare module 'ember-simple-auth/authenticators/base' {
  import EmberObject from '@ember/object';
  import Evented from '@ember/object/evented';

  class Base extends EmberObject.extend(Evented) {
    authenticate(...args: any[]): Promise<unknown>;
    invalidate(data?: object, ...args: any[]): Promise<void>;
    restore(data: object): Promise<unknown>;
  }

  export = Base;
}
