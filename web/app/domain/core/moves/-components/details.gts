import { on } from '@ember/modifier';

import { Page } from '@hokulea/ember';

import { TinaMarkdown } from '../../../supporting/tina';
import { Icon, VideoPlayer } from '../../../supporting/ui';
import { asString } from '../../../supporting/utils';
import { buildMoveLink } from '../-resource';
import styles from './details.css';

import type { Move } from '..';
import type { TOC } from '@ember/component/template-only';

export interface MoveDetailsSignature {
  Args: {
    move: Move;
  };
}

const MoveDetails: TOC<MoveDetailsSignature> = <template>
  <Page class={{styles.page}}>
    <:title><Icon @icon="move" /> {{@move.title}}</:title>
    <:description>
      {{#if @move.description}}
        <TinaMarkdown @content={{@move.description}} />
      {{/if}}

      {{#each @move.tags as |tag|}}
        <code>{{tag}}</code>
      {{/each}}
    </:description>

    <:content>
      <div class={{styles.layout}}>
        <section class={{styles.main}}>
          {{#if @move.video}}
            <VideoPlayer @url={{@move.video}} />
          {{/if}}

          {{#if @move.instruction}}
            <h2>Anleitung</h2>
            <TinaMarkdown @content={{@move.instruction}} />
          {{/if}}
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
                        <a href={{l.url}} {{on "click" l.transitionTo}}>
                          <Icon @icon="exercise" />
                          {{move.data.title}}
                        </a>
                      {{/let}}
                    </li>
                  {{/each}}

                  {{#each @move.links as |see|}}
                    <li>
                      <a href={{see.url}} target="_blank" rel="noopener noreferrer">
                        <Icon @icon="link" />
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
    </:content>
  </Page>
</template>;

export { MoveDetails };
