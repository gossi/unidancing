import Component from '@glimmer/component';

enum Icon {
  learn = '🏫',
  training = '🏋️', // '🏆',
  motion = '🏃',
  literature = '📚',
  skill = '🎓',
  exercise = '🤼',
  move = '💃',
  course = '🎓',
  game = '🎭',
  link = '🌐',
  play = '▶️',
  pause = '⏸️',
  individual = '🧑',
  pair = '🧑‍🤝‍🧑',
  group = '👪',
  pedes = '🦶',
  unicycle = '🚲',
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

export type Icons = keyof typeof Icon;

export function getIcon(icon: Icons) {
  // @ts-ignore - oh kill me !
  return Icon[icon];
}

export interface IconSignature {
  Args: {
    icon: Icons;
  };
}

export default class IconComponent extends Component<IconSignature> {
  <template>
    {{getIcon @icon}}
  </template>
}
