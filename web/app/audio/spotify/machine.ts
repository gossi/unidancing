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
            target: SpotifyState.Authenticated,
            cond: 'isAuthenticated'
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
                  }
                },
                entry: ['load']
              },
              [SpotifyState.Loading]: {
                on: {
                  [SpotifyEvent.DevicesLoaded]: {
                    target: SpotifyState.Selecting
                  }
                }
              },
              [SpotifyState.Selecting]: {
                on: {
                  [SpotifyEvent.SelectDevice]: {
                    target: SpotifyState.Ready
                  }
                },
                entry: 'autoselect'
              },
              [SpotifyState.Ready]: {
                on: {
                  [SpotifyEvent.UnmountDevice]: {
                    target: SpotifyState.Loading
                  }
                }
              }
            }
          },
          [SpotifyState.Playback]: {
            initial: SpotifyState.Paused,
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
    actions: {
      load() {
        console.log('loading...');
      },
      autoselect() {
        console.log('auto select');
      }
    },
    guards: {
      isAuthenticated() {
        console.log('isAuthenticated');
        return true;
      }
    }
  }
);
