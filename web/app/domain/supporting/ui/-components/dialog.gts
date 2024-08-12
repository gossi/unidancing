import Component from '@glimmer/component';

import { modifier } from 'ember-modifier';
import { or } from 'ember-truth-helpers';

import { IconButton } from '@hokulea/ember';

import styles from './dialog.css';

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
    <dialog class={{styles.dialog}} {{this.ref}} ...attributes>
      <IconButton
        @icon="x"
        @label="Schließen"
        @importance="plain"
        @push={{this.close}}
        part="close"
      />

      {{#if (has-block "header")}}
        <div class={{styles.header}} part="header">
          {{yield to="header"}}
        </div>
      {{/if}}

      {{#if (or (has-block "body") (has-block))}}
        <div class={{styles.body}} part="body">
          {{#if (has-block "body")}}
            {{yield to="body"}}
          {{else if (has-block)}}
            {{yield}}
          {{/if}}
        </div>
      {{/if}}
    </dialog>
  </template>
}
