import Helper from '@ember/component/helper';

import type {
  HelperCallback,
  NamedParameters,
  PositionalParameters
} from 'ember-render-helpers/types';

export interface WillDestroySignature {
  Args: {
    Positional: [callback: HelperCallback, ...args: PositionalParameters];
    Named: NamedParameters;
  };
  Return: void;
}

export default class WillDestroyHelper extends Helper<WillDestroySignature> {}
