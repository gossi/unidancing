import Component from '@glimmer/component';

import { Icon as HokIcon } from '@hokulea/ember';

enum Icon {
  learn = '🏫',
  training = '🏋️', // '🏆',
  motion = '🏃',
  literature = '📚',
  skill = '🎓',
  exercise = '🤼',
  move = '💃',
  course = '🎓',
  art = '🎭',
  technique = '🎯', // 🪄,
  game = '🎲',
  link = '🌐',
  play = '▶️',
  pause = '⏸️',
  // individual = '🧑',
  // pair = '🧑‍🤝‍🧑',
  // group = '👪',
  // pedes = '🦶',
  // unicycle = '🚲',
  computer = '💻',
  tv = '🖥️',
  smartphone = '📱',
  speaker = '🔈',
  choreo = '📜',
  plus = '➕',
  trash = '🗑️',
  go = '➡️',
  check = '✅',
  reload = '🔄',
  info = 'ℹ️'
}

enum HokuleaIcon {
  pedes = 'footprints',
  unicycle = 'unicycle',
  individual = 'user',
  pair = 'users',
  group = 'users-three'
}

export type Icons = keyof typeof Icon;

export function getIcon(icon: Icons) {
  return Icon[icon];
}

function getHokuleaIcon(icon: HokuleaIcon) {
  return HokuleaIcon[icon];
}

export interface IconSignature {
  Args: {
    icon: Icons;
  };
}

export default class IconComponent extends Component<IconSignature> {
  get icon() {
    return getIcon(this.args.icon);
  }

  <template>
    {{#if this.icon}}
      {{this.icon}}
    {{else}}
      hok icon: {{getHokuleaIcon @icon}}
      <HokIcon @icon={{getHokuleaIcon @icon}}/>
    {{/if}}
  </template>
}
