import { Icon } from '@hokulea/ember';

import {
  getLocomotionIcon,
  getLocomotionText,
  getPersonalIcon,
  getPersonalText
} from '../-helpers';

import type { Locomotion, Personal } from '../domain-objects';
import type { TOC } from '@ember/component/template-only';

export const FormatPersonalIcon: TOC<{ Args: { personal: Personal } }> = <template>
  <Icon @icon={{getPersonalIcon @personal}} />
</template>;

export const FormatPersonal: TOC<{ Args: { personal: Personal } }> = <template>
  <FormatPersonalIcon @personal={{@personal}} />
  {{getPersonalText @personal}}
</template>;

export const FormatLocomotionIcon: TOC<{ Args: { locomotion: Locomotion } }> = <template>
  <Icon @icon={{getLocomotionIcon @locomotion}} />
</template>;

export const FormatLocomotion: TOC<{ Args: { locomotion: Locomotion } }> = <template>
  <FormatLocomotionIcon @locomotion={{@locomotion}} />
  {{getLocomotionText @locomotion}}
</template>;
