import Component from '@glimmer/component';

enum Icon {
  skill = '🎓',
  exercise = '💃',
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
  check = '✅'
};

export type Icons = keyof typeof Icon;

export function getIcon(icon: Icons) {
  // @ts-ignore - oh kill me !
  return Icon[icon];
}

export interface IconSignature {
  Args: {
    icon: Icons;
  }
}

export default class IconComponent extends Component<IconSignature> {
  <template>
    {{getIcon @icon}}
  </template>
}

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    Icon: typeof IconComponent;
  }
}
