import Helper from '@ember/component/helper';

export interface PageTitleSignature {
  Args: { Positional: [title: string] };
  Return: void;
}

export default class PageTitleHelper extends Helper<PageTitleSignature> {}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    'page-title': typeof PageTitleHelper;
  }
}
