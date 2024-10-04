import { createMachine } from 'xstate';

export const SpotifyMachine = createMachine({
  context: {},
  id: 'SpotifyMachine',
  initial: 'unauthenticated',
  states: {
    unauthenticated: {
      on: {
        authenticate: {
          target: 'authenticated'
        }
      }
    },
    authenticated: {
      initial: 'connecting',
      on: {
        unauthenticate: {
          target: 'unauthenticated'
        }
      },
      states: {
        connecting: {
          invoke: {
            onDone: {
              target: 'ready'
            },
            onError: {
              target: 'errored'
            },
            src: 'connectPlayer'
          }
        },
        ready: {
          always: {
            target: 'playback'
          }
        },
        errored: {},
        playback: {
          initial: 'paused',
          invoke: {
            src: 'loadPlayback'
          },
          states: {
            paused: {
              on: {
                play: {
                  target: 'playing'
                }
              }
            },
            playing: {
              on: {
                pause: {
                  target: 'paused'
                }
              }
            }
          }
        }
      }
    }
  }
}).withConfig({
  services: {
    connectPlayer: createMachine({
      /* ... */
    }),
    loadPlayback: createMachine({
      /* ... */
    })
  }
});
