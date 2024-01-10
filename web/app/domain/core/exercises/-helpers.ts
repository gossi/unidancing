// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import { getIcon } from '@unidancing/ui';

import type { Locomotion, Personal } from './-types';
import type { Maybe } from '@/tina/types';
// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import type { Icons } from '@unidancing/ui';

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

export function asLocomotion(locomotion?: Locomotion | string | Maybe<string>): Locomotion {
  return locomotion as Locomotion;
}

export function formatPersonalIcon(personal: Personal) {
  return getIcon(personal as Icons);
}

export function formatPersonalText(personal: Personal) {
  switch (personal) {
    case 'individual':
      return 'Einzel';

    case 'pair':
      return 'Paar';

    case 'group':
      return 'Gruppe';
  }
}

export function formatPersonal(personal: Personal, options: { icon?: boolean; text?: boolean }) {
  options = { ...DEFAULT, ...options };

  const out = [];

  if (options.icon) {
    out.push(formatPersonalIcon(personal));
  }

  if (options.text) {
    out.push(formatPersonalText(personal));
  }

  return out.join(' ');
}

export function asPersonal(personal?: Personal | string | Maybe<string>): Personal {
  return personal as Personal;
}
