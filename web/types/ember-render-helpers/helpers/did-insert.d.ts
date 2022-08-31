import type {
  HelperCallback,
  PositionalParameters,
  NamedParameters
} from 'ember-render-helpers/types';
import Helper from '@ember/component/helper';

export interface DidInsertSignature {
  Args: {
    Positional: [callback: HelperCallback, ...args: PositionalParameters];
    Named: NamedParameters;
  };
  Return: void;
}

export default class DidInsertHelper extends Helper<DidInsertSignature> {}
