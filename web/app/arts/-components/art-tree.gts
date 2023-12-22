import { buildArtLink } from '..';
import { on } from '@ember/modifier';

import type { Art } from '..';
import type { TOC } from '@ember/component/template-only';

export interface ArtTreeSignature {
  Args: {
    arts: Art[];
  };
}

type ArtNode = {
  item: Art;
  children: ArtNode[];
};

function listToTree(items: Art[], parent?: Art): ArtNode[] {
  return items
    .filter((art) => art.parent?.id === parent?.id)
    .map((art) => ({ item: art, children: listToTree(items, art) }));
}

const Tree: TOC<{ Args: { nodes: ArtNode[] } }> = <template>
  <ul>
    {{#each @nodes as |node|}}
      <li>
        {{#let (buildArtLink node.item._sys.filename) as |l|}}
          <a href={{l.url}} {{on 'click' l.transitionTo}}>
            {{node.item.title}}
          </a>
        {{/let}}

        {{#if node.children}}
          <Tree @nodes={{node.children}} />
        {{/if}}
      </li>
    {{/each}}
  </ul>
</template>;

const ArtTree: TOC<ArtTreeSignature> = <template><Tree @nodes={{(listToTree @arts)}} /></template>;

export { ArtTree };
