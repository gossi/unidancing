import { createMachine } from 'xstate';

// eslint-disable-next-line @typescript-eslint/no-empty-interface
export interface SpotifyContext {}

export enum SpotifyStateNames {
  Authenticated = 'authenticated',
  Unauthenticated = 'unauthenticated',
  Device = 'device',
  Pending = 'pending',
  Loading = 'loading',
  Selecting = 'selecting',
  Ready = 'ready',
  Playback = 'playback',
  Playing = 'playing',
  Paused = 'paused'
}

export enum SpotifyEventNames {
  Authenticate = 'authenticate',
  Unauthenticate = 'unauthenticate',
  Play = 'play',
  Pause = 'pause',
  LoadDevices = 'loadDevices',
  DevicesLoaded = 'devicesLoaded',
  SelectDevice = 'selectDevice',
  UnmountDevice = 'unmountDevice'
}

export type SpotifyEvent =
  | { type: SpotifyEventNames.Authenticate }
  | { type: SpotifyEventNames.Unauthenticate }
  | { type: SpotifyEventNames.Play }
  | { type: SpotifyEventNames.Pause }
  | { type: SpotifyEventNames.LoadDevices }
  | { type: SpotifyEventNames.DevicesLoaded }
  | { type: SpotifyEventNames.SelectDevice }
  | { type: SpotifyEventNames.UnmountDevice };

export type SpotifyState =
  | { value: SpotifyStateNames.Authenticated; context: SpotifyContext }
  | { value: SpotifyStateNames.Unauthenticated; context: SpotifyContext }
  | {
      value: {
        [SpotifyStateNames.Authenticated]: {
          [SpotifyStateNames.Playback]: SpotifyStateNames.Paused;
        };
      };
      context: SpotifyContext;
    }
  | {
      value: {
        [SpotifyStateNames.Authenticated]: {
          [SpotifyStateNames.Playback]: SpotifyStateNames.Playing;
        };
      };
      context: SpotifyContext;
    }
  | {
      value: {
        [SpotifyStateNames.Authenticated]: {
          [SpotifyStateNames.Device]: SpotifyStateNames.Pending;
        };
      };
      context: SpotifyContext;
    }
  | {
      value: {
        [SpotifyStateNames.Authenticated]: {
          [SpotifyStateNames.Device]: SpotifyStateNames.Loading;
        };
      };
      context: SpotifyContext;
    }
  | {
      value: {
        [SpotifyStateNames.Authenticated]: {
          [SpotifyStateNames.Device]: SpotifyStateNames.Selecting;
        };
      };
      context: SpotifyContext;
    }
  | {
      value: {
        [SpotifyStateNames.Authenticated]: {
          [SpotifyStateNames.Device]: SpotifyStateNames.Ready;
        };
      };
      context: SpotifyContext;
    };

export const SpotifyMachine = createMachine<SpotifyContext, SpotifyEvent, SpotifyState>(
  {
    id: 'spotify',
    initial: SpotifyStateNames.Unauthenticated,
    states: {
      [SpotifyStateNames.Unauthenticated]: {
        on: {
          [SpotifyEventNames.Authenticate]: {
            target: SpotifyStateNames.Authenticated
          }
        }
      },
      [SpotifyStateNames.Authenticated]: {
        type: 'parallel',
        states: {
          [SpotifyStateNames.Device]: {
            initial: SpotifyStateNames.Pending,
            states: {
              [SpotifyStateNames.Pending]: {
                on: {
                  [SpotifyEventNames.LoadDevices]: {
                    target: SpotifyStateNames.Loading
                  },
                  '': [
                    { target: SpotifyStateNames.Selecting, cond: 'hasDevices' },
                    { target: SpotifyStateNames.Loading }
                  ]
                }
              },
              [SpotifyStateNames.Loading]: {
                invoke: {
                  src: 'loadDevices',
                  onDone: {
                    target: SpotifyStateNames.Selecting
                  }
                }
              },
              [SpotifyStateNames.Selecting]: {
                invoke: {
                  src: 'autoselectDevice',
                  onDone: {
                    target: SpotifyStateNames.Ready
                  }
                },
                on: {
                  [SpotifyEventNames.SelectDevice]: {
                    target: SpotifyStateNames.Ready
                  }
                }
              },
              [SpotifyStateNames.Ready]: {
                on: {
                  [SpotifyEventNames.UnmountDevice]: [
                    {
                      target: SpotifyStateNames.Selecting,
                      cond: 'hasDevices'
                    },
                    {
                      target: SpotifyStateNames.Loading
                    }
                  ]
                }
              }
            }
          },
          [SpotifyStateNames.Playback]: {
            initial: SpotifyStateNames.Paused,
            invoke: {
              src: 'loadPlayback'
            },
            states: {
              [SpotifyStateNames.Paused]: {
                on: {
                  [SpotifyEventNames.Play]: {
                    target: SpotifyStateNames.Playing
                  }
                }
              },
              [SpotifyStateNames.Playing]: {
                on: {
                  [SpotifyEventNames.Pause]: {
                    target: SpotifyStateNames.Paused
                  }
                }
              }
            }
          }
        },
        on: {
          [SpotifyEventNames.Unauthenticate]: {
            target: SpotifyStateNames.Unauthenticated
          }
        }
      }
    }
  },
  {
    // services: {
    //   /*loadDevices() {
    //     console.log("loading devices...");
    //   },
    //   autoselectDevice() {
    //     console.log("auto select");
    //   },*/
    // },
    guards: {
      hasDevices() {
        return false;
      }
    }
  }
);
