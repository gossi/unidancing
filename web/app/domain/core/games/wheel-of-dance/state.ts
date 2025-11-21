/* eslint-disable @typescript-eslint/no-empty-function */
import { createMachine } from 'xstate';

import { WheelOfFortuneDefaults } from './data';

export const Machine = createMachine(
  {
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
  },
  {
    actions: {
      play: function (_context, _event) {},
      roll: function (_context, _event) {},
      dance: function (_context, _event) {},
      stop: function (_context, _event) {},
      startSelection: function (_context, _event) {},
      stopSelection: function (_context, _event) {}
    }
  }
);
