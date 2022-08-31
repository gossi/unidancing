import { helper } from '@ember/component/helper';
import { Locomotion } from '../database/exercises';
import { getIcon, Icons } from '../components/icon';

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
}

export interface FormatLocomotionSignature {
  Args: {
    Positional: [Locomotion];
    Named: { icon?: boolean; text?: boolean };
  };
  Return: string;
}

const DEFAULT = { icon: true, text: false };

const formatLocomotionHelper =
  helper<FormatLocomotionSignature>(formatLocomotion);

export default formatLocomotionHelper;

declare module '@glint/environment-ember-loose/registry' {
  export default interface Registry {
    'format-locomotion': typeof formatLocomotionHelper;
  }
}
