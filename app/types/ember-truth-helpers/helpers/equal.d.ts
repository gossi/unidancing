// import { ContentValue } from '@glint/template';
import Helper from '@ember/component/helper';

export interface EqualityHelperSignature {
  Args: { Positional: [unknown, unknown] };
  Return: boolean;
}

export default class EqualHelper extends Helper<EqualityHelperSignature> {}
