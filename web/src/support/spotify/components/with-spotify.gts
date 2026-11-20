import { isAuthenticated } from '../abilities';
import { LoginWithSpotify } from './login-with-spotify';

import type { TOC } from '@ember/component/template-only';

const WithSpotify: TOC<{ Blocks: { default: [] } }> = <template>
  {{#if (isAuthenticated)}}
    {{yield}}
  {{else}}
    <LoginWithSpotify />
  {{/if}}
</template>;

export { WithSpotify };
