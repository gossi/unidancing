import { createMachine } from 'xstate';

export enum SpotifyState {
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

export enum SpotifyEvent {
  Authenticate = 'authenticate',
  Unauthenticate = 'unauthenticate',
  Play = 'play',
  Pause = 'pause',
  LoadDevices = 'loadDevices',
  DevicesLoaded = 'devicesLoaded',
  SelectDevice = 'selectDevice',
  UnmountDevice = 'unmountDevice'
}

export const SpotifyMachine = createMachine(
  {
    id: 'spotify',
    initial: SpotifyState.Unauthenticated,
    states: {
      [SpotifyState.Unauthenticated]: {
        on: {
          [SpotifyEvent.Authenticate]: {
            target: SpotifyState.Authenticated
          }
        }
      },
      [SpotifyState.Authenticated]: {
        type: 'parallel',
        states: {
          [SpotifyState.Device]: {
            initial: SpotifyState.Pending,
            states: {
              [SpotifyState.Pending]: {
                on: {
                  [SpotifyEvent.LoadDevices]: {
                    target: SpotifyState.Loading
                  },
                  '': [
                    { target: SpotifyState.Selecting, cond: 'hasDevices' },
                    { target: SpotifyState.Loading }
                  ]
                }
              },
              [SpotifyState.Loading]: {
                invoke: {
                  src: 'loadDevices',
                  onDone: {
                    target: SpotifyState.Selecting
                  }
                }
              },
              [SpotifyState.Selecting]: {
                invoke: {
                  src: 'autoselectDevice'
                },
                on: {
                  [SpotifyEvent.SelectDevice]: {
                    target: SpotifyState.Ready
                  }
                }
              },
              [SpotifyState.Ready]: {
                on: {
                  [SpotifyEvent.SelectDevice]: {
                    target: SpotifyState.Ready
                  },
                  [SpotifyEvent.UnmountDevice]: [
                    {
                      target: SpotifyState.Selecting,
                      cond: 'hasDevices'
                    },
                    {
                      target: SpotifyState.Loading
                    }
                  ]
                }
              }
            }
          },
          [SpotifyState.Playback]: {
            initial: SpotifyState.Paused,
            invoke: {
              src: 'loadPlayback'
            },
            states: {
              [SpotifyState.Paused]: {
                on: {
                  [SpotifyEvent.Play]: {
                    target: SpotifyState.Playing
                  }
                }
              },
              [SpotifyState.Playing]: {
                on: {
                  [SpotifyEvent.Pause]: {
                    target: SpotifyState.Paused
                  }
                }
              }
            }
          }
        },
        on: {
          [SpotifyEvent.Unauthenticate]: {
            target: SpotifyState.Unauthenticated
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
