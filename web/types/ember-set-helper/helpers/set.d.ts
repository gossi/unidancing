import Helper from '@ember/component/helper';

export interface SetSignature {
  Args: {
    Positional: [target: object, path: string, maybeValue?: unknown];
  };
  Return: (...args: unkown[]) => unkown;
}

export default class SetHelper extends Helper<SetSignature> {}
