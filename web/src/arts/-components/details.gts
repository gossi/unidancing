import { Page } from '@hokulea/ember';

import { TinaMarkdown } from '../../../supporting/tina';
import { VideoPlayer } from '../../../supporting/ui';

import type { Art } from '..';
import type { TOC } from '@ember/component/template-only';

export interface ArtDetailsSignature {
  Args: {
    art: Art;
  };
}

const ArtDetails: TOC<ArtDetailsSignature> = <template>
  <Page @title={{@art.title}} class="art">

    {{#if @art.video}}
      <VideoPlayer @url={{@art.video}} />
    {{/if}}

    <TinaMarkdown @content={{@art.body}} />

    {{!-- {{#each @art.techniques as |technique|}}

    {{/each}} --}}
  </Page>
  <style scoped>
    .art {
      header h1 {
        padding-block-start: 0;
      }

      iframe {
        margin-bottom: var(--block-spacing-vertical);
      }
    }
  </style>
</template>;

export { ArtDetails };
