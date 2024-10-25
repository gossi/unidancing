import Component from '@glimmer/component';

import { Icon as HokIcon } from '@hokulea/ember';

const Icon = {
  learn: '🏫',
  training: '🏋️', // '🏆',
  motion: '🏃',
  literature: '📚',
  skill: '🎓',
  exercise: '🤼',
  move: '💃',
  course: '🎓',
  art: '🎭',
  technique: '🎯', // 🪄,
  game: '🎲',
  link: '🌐',
  play: '▶️',
  pause: '⏸️',
  // individual:  '🧑',
  // pair:  '🧑‍🤝‍🧑',
  // group:  '👪',
  // pedes:  '🦶',
  // unicycle:  '🚲',
  computer: '💻',
  tv: '🖥️',
  smartphone: '📱',
  speaker: '🔈',
  choreo: '📜',
  plus: '➕',
  trash: '🗑️',
  go: '➡️',
  check: '✅',
  reload: '🔄',
  info: 'ℹ️'
} as const;

const HokuleaIcon = {
  pedes: 'footprints',
  unicycle: 'unicycle',
  individual: 'user',
  pair: 'users',
  group: 'users-three'
} as const;

export type Icons = keyof typeof Icon;
export type HokuleaIcons = keyof typeof HokuleaIcon;

export function getIcon(icon: Icons) {
  return Icon[icon];
}

export function getHokuleaIcon(icon: HokuleaIcons) {
  return HokuleaIcon[icon];
}

function asHokuleaIcon(icon: Icons | HokuleaIcons): HokuleaIcons {
  return icon as HokuleaIcons;
}

export interface IconSignature {
  Args: {
    icon: Icons | HokuleaIcons;
  };
}

export default class IconComponent extends Component<IconSignature> {
  get icon() {
    return getIcon(this.args.icon as Icons);
  }

  <template>
    {{#if this.icon}}
      {{this.icon}}
    {{else}}
      <HokIcon @icon={{getHokuleaIcon (asHokuleaIcon @icon)}} />
    {{/if}}
  </template>
}
