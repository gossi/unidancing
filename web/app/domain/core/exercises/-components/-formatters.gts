import Component from '@glimmer/component';

import { Icon } from '@hokulea/ember';

import { getLocomotionIcon, getLocomotionText,getPersonalIcon, getPersonalText } from '../-helpers';

import type { Locomotion, Personal } from '../-types';
import type TOC from '@glimmer/component/template-only';

const DEFAULT = { icon: true, text: false };

export const FormatPersonalIcon: TOC<{Args: { personal: Personal }}> = <template>
  <Icon @icon={{getPersonalIcon @personal}}/>
</template>;

export class FormatPersonal extends Component<{Args: {personal: Personal, options: { icon?: boolean; text?: boolean }}}> {
  get options() {
    return { ...DEFAULT, ...this.args.options };
  }

  <template>
    {{#if this.options.icon}}
      <FormatPersonalIcon @personal={{@personal}} />
    {{/if}}

    {{#if this.options.text}}
      {{getPersonalText @personal}}
    {{/if}}
  </template>
}


export const FormatLocomotionIcon: TOC<{Args: { locomotion: Locomotion }}> = <template>
  <Icon @icon={{getLocomotionIcon @locomotion}}/>
</template>;


export class FormatLocomotion extends Component<{Args: {locomotion: Locomotion, options: { icon?: boolean; text?: boolean }}}> {
  get options() {
    return { ...DEFAULT, ...this.args.options };
  }

  <template>
    {{#if this.options.icon}}
      <FormatLocomotionIcon @locomotion={{@locomotion}} />
    {{/if}}

    {{#if this.options.text}}
      {{getLocomotionText @locomotion}}
    {{/if}}
  </template>
}
