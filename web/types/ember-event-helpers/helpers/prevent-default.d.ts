import Helper from '@ember/component/helper';

export interface PreventDefaultSignature {
  Args: {
    Positional: [handler: (event: Event) => void];
  };
  // eslint-disable-next-line @typescript-eslint/naming-convention
  Return: (event: Event) => void;
}

export default class PreventDefaultHelper extends Helper<PreventDefaultSignature> {}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    // eslint-disable-next-line @typescript-eslint/naming-convention
    'prevent-default': typeof PreventDefaultHelper;
  }
}
