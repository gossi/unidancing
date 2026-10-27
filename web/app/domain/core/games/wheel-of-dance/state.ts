/* eslint-disable @typescript-eslint/no-empty-function */
import { setup } from 'xstate';

import { WheelOfFortuneDefaults } from './data';

import type { Context } from './data';

export const Machine = setup({
  types: {
    context: {} as Context,
    events: {} as
      // eslint-disable-next-line unicorn/prefer-type-literal-last
      | ({ type: 'play' } & Context)
      | { type: 'settings' }
      | { type: 'roll' }
      | { type: 'prepare' }
      | { type: 'dance' }
      | { type: 'stop' }
  },
  // Stubs that `wheel-of-dance.gts` replaces through `Machine.provide()` —
  // the role v4's second-argument `actions` implementations served. (`prepare`
  // was never implemented in v4 either; the stub keeps that no-op reference
  // valid under v5.)
  actions: {
    play: () => {},
    roll: () => {},
    prepare: () => {},
    dance: () => {},
    stop: () => {},
    startSelection: () => {},
    stopSelection: () => {}
  }
}).createMachine({
  context: WheelOfFortuneDefaults,
  id: 'Wheel of Fortune',
  initial: 'lobby',
  states: {
    lobby: {
      on: {
        play: {
          target: 'selecting',
          actions: {
            type: 'play'
          }
        }
      }
    },
    selecting: {
      on: {
        settings: {
          target: 'lobby'
        },
        roll: {
          target: 'rolling',
          actions: {
            type: 'roll'
          }
        }
      },
      entry: {
        type: 'startSelection'
      },
      exit: {
        type: 'stopSelection'
      }
    },
    rolling: {
      on: {
        prepare: {
          target: 'preparing',
          actions: {
            type: 'prepare'
          }
        }
      }
    },
    preparing: {
      on: {
        dance: {
          target: 'dancing'
        }
      }
    },
    dancing: {
      on: {
        stop: {
          target: 'selecting',
          actions: {
            type: 'stop'
          }
        }
      },
      entry: {
        type: 'dance'
      }
    }
  }
});
