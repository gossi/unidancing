import { assertEvent, fromPromise, log, setup } from 'xstate';

export const SpotifyMachine = setup({
  types: {
    events: {} as
      | { type: 'authenticate'; accessToken: string }
      | { type: 'unauthenticate' }
      | { type: 'loadDevices' }
      | { type: 'selectDevice' }
      | { type: 'unmountDevice' }
      | { type: 'play' }
      | { type: 'pause' }
  },
  guards: {
    hasDevices: () => false
  },
  // Stubs that `SpotifyClient` replaces per-instance through
  // `SpotifyMachine.provide()` — the role v4's `withConfig({ services })`
  // placeholders served.
  actors: {
    connectPlayer: fromPromise<void, { accessToken: string }>(() => Promise.resolve()),
    loadDevices: fromPromise(() => Promise.resolve()),
    autoselectDevice: fromPromise(() => Promise.resolve()),
    loadPlayback: fromPromise(() => Promise.resolve())
  }
}).createMachine({
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
                  guard: 'hasDevices'
                },
                onError: {
                  target: 'loading'
                },
                src: 'connectPlayer',
                // v4 services received `(context, event)`; v5 promise actors
                // only see `input`, so map the authenticate payload through.
                input: ({ event }) => {
                  assertEvent(event, 'authenticate');

                  return { accessToken: event.accessToken };
                }
              }
            },
            loading: {
              invoke: {
                onDone: {
                  target: 'selecting'
                },
                // v4 tolerated a missing onError with a warning and stayed in
                // the state; v5 would stop the actor, so log and stay.
                onError: {
                  actions: log(({ event }) => event)
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
                src: 'autoselectDevice',
                onError: {
                  actions: log(({ event }) => event)
                }
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
                    guard: 'hasDevices'
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
            src: 'loadPlayback',
            onError: {
              actions: log(({ event }) => event)
            }
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
});
