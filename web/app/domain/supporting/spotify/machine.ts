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
      type: 'parallel',
      on: {
        unauthenticate: {
          target: 'unauthenticated'
        }
      },
      states: {
        device: {
          initial: 'connecting',
          states: {
            connecting: {
              on: {
                loadDevices: {
                  target: 'loading'
                }
              },
              invoke: {
                onDone: {
                  target: 'selecting',
                  cond: 'hasDevices'
                },
                onError: {
                  target: 'loading'
                },
                src: 'connectPlayer'
              }
            },
            loading: {
              invoke: {
                id: 'spotify.authenticated.device.loading:invocation[0]',
                onDone: {
                  target: 'selecting'
                },
                src: 'loadDevices'
              }
            },
            selecting: {
              on: {
                selectDevice: {
                  target: 'ready'
                }
              },
              invoke: {
                id: 'spotify.authenticated.device.selecting:invocation[0]',
                src: 'autoselectDevice'
              }
            },
            ready: {
              on: {
                selectDevice: {
                  target: 'ready'
                },
                unmountDevice: [
                  {
                    target: 'selecting',
                    cond: 'hasDevices'
                  },
                  {
                    target: 'loading'
                  }
                ]
              }
            }
          }
        },
        playback: {
          initial: 'paused',
          invoke: {
            id: 'spotify.authenticated.playback:invocation[0]',
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
  guards: {
    hasDevices() {
      return false;
    }
  },
  services: {
    connectPlayer: createMachine({
      /* ... */
    }),
    loadDevices: createMachine({
      /* ... */
    }),
    autoselectDevice: createMachine({
      /* ... */
    }),
    loadPlayback: createMachine({
      /* ... */
    })
  }
});
