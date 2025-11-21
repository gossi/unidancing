import { action } from 'ember-command';

import { AudioService } from './service';
import styles from './soundboard.css';
import { countDown, counter, fail, select, slotMachineWheel, surprise } from './sounds';

export class SoundBoard {
  #sounds: Map<string, HTMLAudioElement> = new Map<string, HTMLAudioElement>();

  constructor() {
    this.addSound('fail', fail);
    this.addSound('counter', counter);
    this.addSound('countDown', countDown);
    this.addSound('select', select);
    this.addSound('surprise', surprise);
    this.addSound('slot-machine-wheel', slotMachineWheel);
  }

  addSound(name: string, src: string) {
    try {
      const audio = document.createElement('audio');

      audio.src = src;
      audio.classList.add(styles.soundboard);
      audio.dataset.name = name;
      document.body.append(audio);
      this.#sounds.set(name, audio);
    } catch {
      // fastboot will report on document to not be defined, but also doesn't let
      // you check for it
    }
  }

  play(name: string): Promise<void> | undefined {
    if (this.#sounds.has(name)) {
      const audio = this.#sounds.get(name) as HTMLAudioElement;

      return audio.play();
    }

    return undefined;
  }
}

export const playSound = action(({ service }) => async (name: string) => {
  const soundboard = service(AudioService).soundboard;

  return soundboard.play(name);
});
