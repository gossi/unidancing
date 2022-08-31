import type {
  HelperCallback,
  PositionalParameters,
  NamedParameters
} from 'ember-render-helpers/types';
import Helper from '@ember/component/helper';

export interface WillDestroySignature {
  Args: {
    Positional: [callback: HelperCallback, ...args: PositionalParameters];
    Named: NamedParameters;
  };
  Return: void;
}

export default class WillDestroyHelper extends Helper<WillDestroySignature> {}
