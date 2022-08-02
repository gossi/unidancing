import { helper } from '@ember/component/helper';
import { Locomotion } from '../database/exercises';

export function formatLocomotionIcon(locomotion: Locomotion) {
  switch (locomotion) {
    case 'pedes':
      return '🦶';

    case 'unicycle':
      return '🚲';
  }
}

export function formatLocomotionText(locomotion: Locomotion) {
  switch (locomotion) {
    case 'pedes':
      return 'per Pedes';

    case 'unicycle':
      return 'per Unicycle';
  }
}

const DEFAULT = { icon: true, text: false };

export default helper(function (
  [locomotion]: [Locomotion],
  options: { icon: boolean; text: boolean }
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
});
