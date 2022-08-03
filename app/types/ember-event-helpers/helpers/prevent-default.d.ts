import Helper from '@ember/component/helper';

export interface PreventDefaultSignature {
  Args: {
    Positional: [handler: (event: Event) => void];
  };
  Return: (event: Event) => void;
}

export default class PreventDefaultHelper extends Helper<PreventDefaultSignature> {}
