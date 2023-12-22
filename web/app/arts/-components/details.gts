import { TinaMarkdown, VideoPlayer } from '../../components';
import styles from './details.css';

import type { Art } from '..';
import type { TOC } from '@ember/component/template-only';

export interface ArtDetailsSignature {
  Args: {
    art: Art;
  };
}

const ArtDetails: TOC<ArtDetailsSignature> = <template>
  <section class={{styles.main}}>
    <h2>{{@art.title}}</h2>

    {{#if @art.video}}
      <VideoPlayer @url={{@art.video}}/>
    {{/if}}

    <TinaMarkdown @content={{@art.body}} />
  </section>

  {{!-- {{#each @art.techniques as |technique|}}

  {{/each}} --}}
</template>

export { ArtDetails };
