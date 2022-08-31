// import { ContentValue } from '@glint/template';
import Helper from '@ember/component/helper';

export interface NotHelperSignature {
  Args: { Positional: [unknown] };
  Return: boolean;
}

export default class NotHelper extends Helper<NotHelperSignature> {}
