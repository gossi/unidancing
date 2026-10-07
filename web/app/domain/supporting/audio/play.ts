import { action } from 'ember-command';

import { AudioService } from './service';

export const playSound = action(({ service }) => async (name: string) => {
  const soundboard = service(AudioService).soundboard;

  return soundboard.play(name);
});
