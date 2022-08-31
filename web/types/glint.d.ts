import '@glint/environment-ember-loose/native-integration';
import '@glint/environment-ember-loose/registry';
import '@glint/environment-ember-loose';

import { ComponentLike, HelperLike } from '@glint/template';
import {
  LinkHelperPositionalParams,
  LinkHelperNamedParams
} from 'ember-link/helpers/link';
import { UILink } from 'ember-link';

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    link: HelperLike<{
      Args: {
        Positional: LinkHelperPositionalParams;
        Named: LinkHelperNamedParams;
      };
      Return: UILink;
    }>;
  }
}
