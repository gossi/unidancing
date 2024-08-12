import { fn } from '@ember/helper';

import { TinaMarkdown } from '@unidancing/app/domain/supporting/tina';
import { asString } from '@unidancing/app/domain/supporting/utils';
import { and, or } from 'ember-truth-helpers';

import { Button } from '@hokulea/ember';

import { Dialog, VideoPlayer } from '../../../supporting/ui';
import { formatDuration, formatMethod, formatMethodAbbr } from '../-helpers';
import { asMediaCollection } from '../domain-objects';
import styles from './instruction.css';
import { Media } from './media';

import type { Instruction as ExerciseInstruction } from '../domain-objects';
import type { TOC } from '@ember/component/template-only';

function openDialog(id: string) {
  const diag = document.getElementById(id);

  if (diag) {
    (diag as HTMLDialogElement).showModal();
  }
}

interface InstructionSignature {
  Args: {
    instructions: ExerciseInstruction[];
  };
}

export const Instruction: TOC<InstructionSignature> = <template>
  <div class={{styles.curriculum}}>
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

          <div data-duration>{{formatDuration s.duration}}</div>
          <div data-instruction>
            {{#if s.move}}
              <TinaMarkdown @content={{s.move.instruction}} />
            {{/if}}

            {{#if s.content}}
              <TinaMarkdown @content={{s.content}} />
            {{/if}}
          </div>
          <div data-method>
            <abbr title={{formatMethod s.method}}>{{formatMethodAbbr s.method}}</abbr>
          </div>
          <div data-media>
            {{#if (and s.media)}}
              <Media @media={{asMediaCollection s.media}} />
            {{/if}}

            {{#if (and s.move s.move.video)}}
              <Button
                @importance="subtle"
                @spacing="-1"
                @push={{fn openDialog s.move._sys.filename}}
              >
                Video
              </Button>

              <Dialog id={{s.move._sys.filename}} class={{styles.video}}>
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
</template>;
