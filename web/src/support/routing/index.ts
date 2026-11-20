import type { DSL, DSLCallback } from '@ember/routing/lib/dsl';

export function buildRoutes(callback: DSLCallback) {
  return (context: DSL) => {
    callback.apply(context);
  };
}
