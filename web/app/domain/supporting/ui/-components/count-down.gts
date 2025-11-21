import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { registerDestructor } from '@ember/destroyable';
import { getOwner } from '@ember/owner';

import { dropTask, timeout } from 'ember-concurrency';

import { playSound } from '../../audio';
import styles from './count-down.css';

import type { TOC } from '@ember/component/template-only';
import type Owner from '@ember/owner';

export const Digit: TOC<{ Blocks: { default: [] } }> = <template>
  <p class={{styles.counter}}>{{yield}}</p>
</template>;

interface CountDownSignature {
  Args: {
    duration: number;
    sound?: boolean;
    finished?: () => void;
  };
}

export class CountDown extends Component<CountDownSignature> {
  @tracked counter?: number;

  playSound = playSound(getOwner(this) as Owner);

  constructor(owner: Owner, args: CountDownSignature['Args']) {
    super(owner, args);

    registerDestructor(this, () => void this.countDown.cancelAll());

    void this.countDown.perform();
  }

  countDown = dropTask(async () => {
    this.counter = this.args.duration;

    while (this.counter > 0) {
      if (this.args.sound) {
        void this.playSound('counter');
      }

      await timeout(1000);
      this.counter--;
    }

    this.args.finished?.();
  });

  <template>
    <Digit>{{this.counter}}</Digit>
  </template>
}
