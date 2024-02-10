import Helper from '@ember/component/helper';

import type {
  HelperCallback,
  NamedParameters,
  PositionalParameters
} from 'ember-render-helpers/types';

export interface DidInsertSignature {
  Args: {
    Positional: [callback: HelperCallback, ...args: PositionalParameters];
    Named: NamedParameters;
  };
  Return: void;
}

export default class DidInsertHelper extends Helper<DidInsertSignature> {}
