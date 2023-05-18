// import { ContentValue } from '@glint/template';
import Helper from '@ember/component/helper';

export interface OrHelperSignature {
  Args: { Positional: [unknown] };
  Return: boolean;
}

export default class OrHelper extends Helper<OrHelperSignature> {}
