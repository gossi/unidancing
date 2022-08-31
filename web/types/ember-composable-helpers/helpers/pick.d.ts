import Helper from '@ember/component/helper';

export interface PickSignature {
  Args: {
    Positional: [path: string, handler: (value: unknown) => void];
  };
  Return: (value: unknown) => void;
}

export default class PickHelper extends Helper<PickSignature> {}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    pick: typeof PickHelper;
  }
}
