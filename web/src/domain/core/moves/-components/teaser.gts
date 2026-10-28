import { Card } from '@hokulea/ember';

import { TinaMarkdown } from '../../../supporting/tina';
import { Icon, Tag } from '../../../supporting/ui';
import { buildMoveLink } from '../-resource';

import type { Move } from '..';
import type { TOC } from '@ember/component/template-only';

export interface MoveTeaserSignature {
  Args: {
    move: Move;
  };
}

const MoveTeaser: TOC<MoveTeaserSignature> = <template>
  <Card class="teaser">
    <:header>
      <span>
        <Icon @icon="move" />

        {{#let (buildMoveLink @move._sys.filename) as |l|}}
          <a href={{l.url}} {{on "click" l.transitionTo}}>
            {{@move.title}}
          </a>
        {{/let}}
      </span>
      <div>
        {{#each @move.tags as |tag|}}
          <Tag>{{tag}}</Tag>
        {{/each}}
      </div>
    </:header>
    <:body>
      <TinaMarkdown @content={{@move.description}} />
    </:body>
  </Card>
  <style scoped>
    .teaser :global([part="header"]) {
      display: flex;
      justify-content: space-between;
    }
  </style>
</template>;

export { MoveTeaser };
