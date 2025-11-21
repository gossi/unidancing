import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { registerDestructor } from '@ember/destroyable';

import { dropTask, timeout } from 'ember-concurrency';
import { modifier } from 'ember-modifier';

import styles from './slot-machine.css';

import type Owner from '@ember/owner';
import type { WithBoundArgs } from '@glint/template';

// eslint-disable-next-line @typescript-eslint/no-explicit-any
function shuffle<T extends any[] = any[]>(arr: T): T {
  let m = arr.length;

  while (m) {
    const i = Math.floor(Math.random() * m--);

    // eslint-disable-next-line @typescript-eslint/no-unsafe-assignment
    [arr[m], arr[i]] = [arr[i], arr[m]];
  }

  return arr;
}

function repeat(arr: string[], amount: number): string[] {
  // eslint-disable-next-line unicorn/no-new-array
  return new Array<string[]>(amount).fill(arr).flat();
}

interface Args {
  options: string[];
  name?: string;
  drawn?: (result: string, slot?: string) => void;
  start?: boolean;
  reset?: boolean;
  register?: (slot: Slot) => void;
  unregister?: (slot: Slot) => void;
}

interface SlotSignature {
  Args: Args;
}

const REPEAT = 5;

class Slot extends Component<SlotSignature> {
  @tracked shuffledOptions = shuffle(this.args.options);

  constructor(owner: Owner, args: Args) {
    super(owner, args);

    this.args.register?.(this);

    if (this.args.unregister) {
      registerDestructor(this, () => this.args.unregister?.(this));
    }
  }

  spin = dropTask(async (duration) => {
    await timeout(duration * 1000);

    this.args.drawn?.(this.shuffledOptions.at(-1) as string, this.args.name);
  });

  animation = modifier(
    (
      e: HTMLDivElement,
      _,
      { start = false, reset = false }: { start?: boolean; reset?: boolean }
    ) => {
      if (start) {
        this.shuffledOptions = shuffle(this.args.options);

        const duration = 2;

        e.style.transitionDuration = `${duration}s`;
        e.style.transform = `translateY(-${this.args.options.length * REPEAT}lh)`;

        e.dataset.spinning = 'true';

        void this.spin.perform(duration).finally(() => {
          delete e.dataset.spinning;
        });
      } else if (reset) {
        e.style.transitionDuration = '';
        e.style.transform = '';
      }
    }
  );

  <template>
    <div class={{styles.slot}}>
      <div class={{styles.boxes}} {{this.animation start=@start reset=@reset}}>
        <div class={{styles.box}}>?</div>
        {{#each (repeat this.shuffledOptions REPEAT) as |option|}}
          <div class={{styles.box}}>{{option}}</div>
        {{/each}}
      </div>
    </div>
  </template>
}

interface SlotMachineSignature {
  Element: HTMLDivElement;
  Args: Partial<Omit<Args, 'name' | 'register' | 'unregister' | 'drawn'>> & {
    drawn?: (result: string | Record<string, string>) => void;
  };
  Blocks: {
    default: [WithBoundArgs<typeof Slot, 'start' | 'register' | 'unregister'>];
  };
}

function asStringArray(strings: string[] | undefined): string[] {
  return strings as string[];
}

class SlotMachine extends Component<SlotMachineSignature> {
  slots = new Set();
  results: Record<string, string> = {};

  register = (slot: Slot) => {
    this.slots.add(slot);
  };

  unregister = (slot: Slot) => {
    this.slots.delete(slot);
  };

  reset = modifier((_, [reset = false]: [boolean | undefined]) => {
    if (reset) {
      this.results = {};
    }
  });

  collectResults = (result: string, slot: string) => {
    this.results[slot] = result;

    if (Object.keys(this.results).length === this.slots.size) {
      this.args.drawn?.(this.results);
    }
  };

  <template>
    <div {{this.reset @reset}} ...attributes>
      {{#if (has-block)}}
        {{yield
          (component
            Slot
            start=@start
            reset=@reset
            drawn=this.collectResults
            register=this.register
            unregister=this.unregister
          )
        }}
      {{else}}
        <Slot @options={{asStringArray @options}} @drawn={{@drawn}} />
      {{/if}}
    </div>
  </template>
}

export { SlotMachine };
