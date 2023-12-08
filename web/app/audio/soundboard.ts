import { action } from 'ember-command';

import styles from './soundboard.css';
import { countDown, counter, fail, select, surprise } from './sounds';

export class SoundBoard {
  #sounds: Map<string, HTMLAudioElement> = new Map<string, HTMLAudioElement>();

  constructor() {
    this.addSound('fail', fail);
    this.addSound('counter', counter);
    this.addSound('countDown', countDown);
    this.addSound('select', select);
    this.addSound('surprise', surprise);
  }

  addSound(name: string, src: string) {
    const audio = document.createElement('audio');

    audio.src = src;
    audio.classList.add(styles.soundboard);
    audio.dataset.name = name;
    document.body.appendChild(audio);

    this.#sounds.set(name, audio);
  }

  play(name: string): Promise<void> | undefined {
    if (this.#sounds.has(name)) {
      const audio = this.#sounds.get(name) as HTMLAudioElement;

      return audio.play();
    }

    return undefined;
  }
}

export const playSound = action(({ services }) => async (name: string) => {
  const soundboard = services.player.soundboard;

  return soundboard.play(name);
});
