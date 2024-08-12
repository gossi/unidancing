import { on } from '@ember/modifier';

import { Card } from '@hokulea/ember';

import { TinaMarkdown } from '../../../supporting/tina';
import { Icon } from '../../../supporting/ui';
import { buildMoveLink } from '../-resource';
import styles from './teaser.css';

import type { Move } from '..';
import type { TOC } from '@ember/component/template-only';

export interface MoveTeaserSignature {
  Args: {
    move: Move;
  };
}

const MoveTeaser: TOC<MoveTeaserSignature> = <template>
  <Card class={{styles.teaser}}>
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
          <code>{{tag}}</code>
        {{/each}}
      </div>
    </:header>
    <:body>
      <TinaMarkdown @content={{@move.description}} />
    </:body>
  </Card>
</template>;

export { MoveTeaser };
