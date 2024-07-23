// eslint-disable-next-line @typescript-eslint/ban-ts-comment
// @ts-ignore
import type { Locomotion, Personal } from './-types';
import type { Maybe } from '@/tina/types';

const enum HokuleaIcon {
  pedes = 'footprints',
  unicycle = 'unicycle',
  individual = 'user',
  pair = 'users',
  group = 'users-three'
}

type Icons = keyof typeof HokuleaIcon;

function getHokuleaIcon(icon: Icons) {
  return HokuleaIcon[icon];
}

export function getLocomotionIcon(locomotion: Locomotion) {
  return getHokuleaIcon(locomotion as unknown as Icons);
}

export function getLocomotionText(locomotion: Locomotion) {
  switch (locomotion) {
    case 'pedes':
      return 'per Pedes';

    case 'unicycle':
      return 'per Unicycle';
  }
}

export function asLocomotion(locomotion?: Locomotion | string | Maybe<string>): Locomotion {
  return locomotion as Locomotion;
}

export function getPersonalIcon(personal: Personal) {
  return getHokuleaIcon(personal as unknown as Icons);
}

export function getPersonalText(personal: Personal) {
  switch (personal) {
    case 'individual':
      return 'Einzel';

    case 'pair':
      return 'Paar';

    case 'group':
      return 'Gruppe';
  }
}

export function asPersonal(personal?: Personal | string | Maybe<string>): Personal {
  return personal as Personal;
}
