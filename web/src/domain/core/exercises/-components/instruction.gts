import { Button } from '@hokulea/ember';

import { TinaMarkdown } from '../../../supporting/tina';
import { Dialog, VideoPlayer } from '../../../supporting/ui';
import { asNumber, asString } from '../../../supporting/utils';
import { asMethod, formatDuration, formatMethod, formatMethodAbbr } from '../-helpers';
import { asMediaCollection } from '../domain-objects';
import { Media } from './media';

import type { Instruction as ExerciseInstruction } from '../domain-objects';
import type { Maybe } from '@/tina/types';
import type { TOC } from '@ember/component/template-only';

function openDialog(id: string) {
  // eslint-disable-next-line unicorn/prefer-query-selector
  const diag = document.getElementById(id);

  if (diag) {
    (diag as HTMLDialogElement).showModal();
  }
}

interface InstructionSignature {
  Args: {
    instructions: Maybe<ExerciseInstruction>[];
  };
}

export const Instruction: TOC<InstructionSignature> = <template>
  <div class="curriculum">
    <div>
      <div data-header>
        <span>Dauer</span>
        <span>Inhalt</span>
        <span>Methode</span>
        <span>Medien</span>
      </div>
      {{#each @instructions as |s|}}
        <div data-step>
          {{#if (or s.title s.move)}}
            <div data-title>
              {{#if s.move.title}}
                <details>
                  <summary>{{s.move.title}}</summary>
                  <TinaMarkdown @content={{s.move.description}} />
                </details>
              {{else}}
                {{s.title}}
              {{/if}}
            </div>
          {{/if}}

          <div data-duration>{{formatDuration (asNumber s.duration)}}</div>
          <div data-instruction>
            {{#if s.move}}
              <TinaMarkdown @content={{s.move.instruction}} />
            {{/if}}

            {{#if s.content}}
              <TinaMarkdown @content={{s.content}} />
            {{/if}}
          </div>
          <div data-method>
            <abbr title={{formatMethod (asMethod (asString s.method))}}>
              {{formatMethodAbbr (asMethod (asString s.method))}}
            </abbr>
          </div>
          <div data-media>
            {{#if s.media}}
              <Media @media={{asMediaCollection s.media}} />
            {{/if}}

            {{#if (and s.move s.move.video)}}
              <Button
                @importance="subtle"
                @spacing="-1"
                {{! @glint-ignore }}
                @push={{fn openDialog s.move._sys.filename}}
              >
                Video
              </Button>

              <Dialog id={{s.move._sys.filename}} class="video">
                <:header>{{s.move.title}}</:header>
                <:body>
                  <VideoPlayer @url={{asString s.move.video}} />
                </:body>
              </Dialog>
            {{/if}}
          </div>
        </div>
      {{/each}}
    </div>
  </div>
  <style scoped>
    .video {
      width: 80vw;
    }

    .curriculum {
      container-type: inline-size;

      & > div {
        display: grid;
        grid-template-columns: repeat(4, auto);

        & > div {
          display: grid;
          grid-column: span 4;
          grid-template-columns: subgrid;

          border-block-start: 1px solid var(--shape-stroke-color);
          border-inline-start: 1px solid var(--shape-stroke-color);

          & > * {
            padding: 0.5rem 0.75rem;
            border-inline-end: 1px solid var(--shape-stroke-color);
          }

          &:last-child {
            border-block-end: 1px solid var(--shape-stroke-color);
          }
        }

        [data-step] {
          & > *:first-child {
            border-block-end: 1px solid var(--shape-stroke-color);
          }
        }

        [data-header] {
          background: var(--surface-container1);
          border-block-end: 1px solid var(--shape-stroke-color);
        }

        [data-title] {
          grid-column: span 4;
          background: var(--surface-container);

          details {
            &[open] summary {
              margin-block-end: var(--spacing-primitive-2);
            }

            :not(summary) {
              color: var(--typography-muted);
            }
          }
        }

        [data-instruction] > * + * {
          margin-block-start: 1em;
        }

        [data-media] > * + * {
          margin-block-start: var(--spacing-primitive-3);
        }

        @container (inline-size < 40em) {
          grid-template-columns: auto;
          gap: var(--spacing-container0);

          & > div {
            grid-column: auto;
            grid-template-areas:
              "title title"
              "duration method"
              "instruction instruction"
              "media media";
            grid-template-columns: 1fr 1fr;
            border-block-end: 0;

            & > * {
              border-block-end: 1px solid var(--shape-stroke-color);
            }

            &:last-child {
              border-block-end: 0;
            }
          }

          [data-header] {
            display: none;
          }

          [data-title] {
            grid-area: title;
            grid-column: auto;
            grid-column: span 2;
          }

          [data-duration] {
            grid-area: duration;
          }

          [data-instruction] {
            grid-area: instruction;
          }

          [data-method] {
            grid-area: method;
          }

          [data-media] {
            grid-area: media;

            /*
            Use :blank when available
            - https://developer.mozilla.org/en-US/docs/Web/CSS/:blank

            Workaround:
            - https://stackoverflow.com/questions/18313689/empty-selector-not-working-in-css
            */
            &:not(:has(*)) {
              display: none;
            }
          }
        }
      }
    }
  </style>
</template>;
