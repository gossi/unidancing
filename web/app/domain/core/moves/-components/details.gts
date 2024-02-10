import { Icon, VideoPlayer } from '../../../supporting/ui';
import { TinaMarkdown } from '../../../supporting/tina';

import { on } from '@ember/modifier';
import styles from './details.css';
import { asString } from '../../../supporting/utils';
import { buildMoveLink } from '../-resource';

import type { Move } from '..';
import type { TOC } from '@ember/component/template-only';

export interface MoveDetailsSignature {
  Args: {
    move: Move;
  };
}

const MoveDetails: TOC<MoveDetailsSignature> = <template>
  <hgroup>
    <h1><Icon @icon='move' /> {{@move.title}}</h1>
    <span class={{styles.tagline}}>
      {{#each @move.tags as |tag|}}
        <code>{{tag}}</code>
      {{/each}}
    </span>
  </hgroup>

  <div class={{styles.layout}}>
    <section class={{styles.main}}>
      {{#if @move.video}}
        <VideoPlayer @url={{@move.video}}/>
      {{/if}}

      <TinaMarkdown @content={{@move.body}} />
    </section>

    <aside>
      <section>
        {{#if @move.moves}}
          <nav>
            Siehe auch:

            <ul>
              {{#each @move.moves as |move|}}
                <li>
                  {{#let (buildMoveLink (asString move.data._sys.filename)) as |l|}}
                    <a href={{l.url}} {{on 'click' l.transitionTo}}>
                      <Icon @icon='exercise' />
                      {{move.data.title}}
                    </a>
                  {{/let}}
                </li>
              {{/each}}

              {{#each @move.links as |see|}}
                <li>
                  <a href={{see.url}} target='_blank'>
                    <Icon @icon='link' />
                    {{if see.label see.label see.url}}
                  </a>
                </li>
              {{/each}}
            </ul>
          </nav>
        {{/if}}
      </section>
    </aside>
  </div>
</template>;

export { MoveDetails };
