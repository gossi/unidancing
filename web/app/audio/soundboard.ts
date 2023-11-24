import styles from './soundboard.css';
import { countDown, counter, fail, select, surprise } from './sounds';

export class SoundBoard {
  #effects: Map<string, HTMLAudioElement> = new Map<string, HTMLAudioElement>();

  constructor() {
    this.addEffect('fail', fail);
    this.addEffect('counter', counter);
    this.addEffect('countDown', countDown);
    this.addEffect('select', select);
    this.addEffect('surprise', surprise);
  }

  addEffect(name: string, src: string) {
    const audio = document.createElement('audio');

    audio.src = src;
    audio.classList.add(styles.soundboard);
    audio.dataset.name = name;
    document.body.appendChild(audio);

    this.#effects.set(name, audio);
  }

  play(name: string): Promise<void> | undefined {
    if (this.#effects.has(name)) {
      const audio = this.#effects.get(name) as HTMLAudioElement;

      return audio.play();
    }

    return undefined;
  }
}

// const SoundBoard = <template>

// </template>

// export default SoundBoard;
