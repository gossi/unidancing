import { Page } from '@hokulea/ember';

import { TinaMarkdown } from '../../../supporting/tina';
import { VideoPlayer } from '../../../supporting/ui';
import styles from './details.css';

import type { Art } from '..';
import type { TOC } from '@ember/component/template-only';

export interface ArtDetailsSignature {
  Args: {
    art: Art;
  };
}

const ArtDetails: TOC<ArtDetailsSignature> = <template>
  <Page @title={{@art.title}} class={{styles.art}}>

    {{#if @art.video}}
      <VideoPlayer @url={{@art.video}} />
    {{/if}}

    <TinaMarkdown @content={{@art.body}} />

    {{!-- {{#each @art.techniques as |technique|}}

    {{/each}} --}}
  </Page>
</template>;

export { ArtDetails };
