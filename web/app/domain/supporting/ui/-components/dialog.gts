import Component from '@glimmer/component';

import { modifier } from 'ember-modifier';

import IconX from '~icons/ph/x';

import { IconButton } from '@hokulea/ember';

export interface DialogSignature {
  Element: HTMLDialogElement;
  Blocks: {
    default: [];
    header: [];
    body: [];
  };
}

export class Dialog extends Component<DialogSignature> {
  element?: HTMLDialogElement;

  ref = modifier((element: HTMLDialogElement) => {
    this.element = element;
  });

  close = () => {
    this.element?.close();
  };

  <template>
    <dialog class="dialog" {{this.ref}} ...attributes>
      <IconButton
        @icon={{IconX}}
        @label="Schließen"
        @importance="plain"
        @push={{this.close}}
        part="close"
      />

      {{#if (has-block "header")}}
        <div class="header" part="header">
          {{yield to="header"}}
        </div>
      {{/if}}

      {{#if (or (has-block "body") (has-block))}}
        <div class="body" part="body">
          {{#if (has-block "body")}}
            {{yield to="body"}}
          {{else if (has-block)}}
            {{yield}}
          {{/if}}
        </div>
      {{/if}}
    </dialog>
    <style scoped>
      .dialog {
        margin: auto;
        padding: var(--spacing-container0);

        color: var(--typography-main);

        background-color: var(--surface-popover);
        border-radius: var(--shape-radius-container);

        [part="close"] {
          position: absolute;
          top: var(--spacing-container-2);
          right: 0;
        }

        &[open]:has([part="header"]) {
          display: grid;
          gap: var(--spacing-container0);
        }
      }

      .header {
        font-size: var(--s2);

        /* background-color: var(--surface-container1); */
      }
    </style>
  </template>
}
