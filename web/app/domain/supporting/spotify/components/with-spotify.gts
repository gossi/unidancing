import LoginWithSpotify from './login-with-spotify';
import type { TOC } from '@ember/component/template-only';
import { isAuthenticated } from '../abilities';

const WithSpotify: TOC<{ Blocks: { default: [] }}> = <template>
  {{#if (isAuthenticated)}}
    {{yield}}
  {{else}}
    <LoginWithSpotify/>
  {{/if}}
</template>

export default WithSpotify;
