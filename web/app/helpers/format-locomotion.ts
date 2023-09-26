import { getIcon } from '../components/icon';

import type { Icons } from '../components/icon';
import type { Locomotion } from '../database/exercises';

const DEFAULT = { icon: true, text: false };

export function formatLocomotionIcon(locomotion: Locomotion) {
  return getIcon(locomotion as Icons);
}

export function formatLocomotionText(locomotion: Locomotion) {
  switch (locomotion) {
    case 'pedes':
      return 'per Pedes';

    case 'unicycle':
      return 'per Unicycle';
  }
}

export function formatLocomotion(
  locomotion: Locomotion,
  options: { icon?: boolean; text?: boolean }
) {
  options = { ...DEFAULT, ...options };

  const out = [];

  if (options.icon) {
    out.push(formatLocomotionIcon(locomotion));
  }

  if (options.text) {
    out.push(formatLocomotionText(locomotion));
  }

  return out.join(' ');
}
