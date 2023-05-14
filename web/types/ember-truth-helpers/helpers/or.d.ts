// import { ContentValue } from '@glint/template';
import Helper from '@ember/component/helper';

export interface OrHelperSignature {
  Args: { Positional: boolean[] };
  Return: boolean;
}

export default class NotHelper extends Helper<OrHelperSignature> {}
