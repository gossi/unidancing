import { ability } from 'ember-ability';

import { SpotifyService } from './service';

export const isAuthenticated = ability(({ service }) => () => {
  return service(SpotifyService).client.authenticated;
});

export const isReadyForPlayback = ability(({ service }) => () => {
  return service(SpotifyService).client.ready;
});

export const isPlaying = ability(({ service }) => () => {
  return service(SpotifyService).client.playing;
});
