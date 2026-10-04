import Component from '@glimmer/component';

import IconBasketball from '~icons/ph/basketball';
import IconLink from '~icons/ph/link';
import IconMedal from '~icons/ph/medal';
import IconPalette from '~icons/ph/palette';
import IconPersonSimpleWalk from '~icons/ph/person-simple-walk';
import IconTarget from '~icons/ph/target';

import { Icon as HokIcon } from '@hokulea/ember';

/**
 * Semantic domain icons for UniDancing content kinds, backed by Phosphor
 * icons via unplugin-icons (replaces the old emoji map).
 */
const Icons = {
  art: IconPalette,
  exercise: IconBasketball,
  link: IconLink,
  move: IconPersonSimpleWalk,
  skill: IconMedal,
  technique: IconTarget
} as const;

export type Icons = keyof typeof Icons;

export function getIcon(icon: Icons) {
  return Icons[icon];
}

export interface IconSignature {
  Element: HTMLSpanElement;
  Args: {
    icon: Icons;
  };
}

export default class IconComponent extends Component<IconSignature> {
  <template><HokIcon @icon={{getIcon @icon}} data-test-icon={{@icon}} ...attributes /></template>
}
