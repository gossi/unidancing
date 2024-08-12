import type { Locomotion, Personal } from './domain-objects';

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

const METHOD = {
  lecture: 'Trainervortrag',
  individual: 'Einzelübung',
  pair: 'Partnerübung',
  group: 'Gruppenübung',
  discussion: 'Diskussion',
  showcase: 'Showcase',
  // eslint-disable-next-line @typescript-eslint/naming-convention
  'frontal-teaching': 'Frontalunterricht'
} as const;

const METHOD_ABBR = {
  lecture: 'TV',
  individual: 'Einzel',
  pair: 'Partner',
  group: 'Gruppe',
  discussion: 'Disc',
  showcase: 'SC',
  // eslint-disable-next-line @typescript-eslint/naming-convention
  'frontal-teaching': 'FU'
} as const;

export function formatMethod(method: keyof typeof METHOD) {
  return METHOD[method];
}

export function formatMethodAbbr(method: keyof typeof METHOD_ABBR) {
  return METHOD_ABBR[method];
}

export function formatDuration(duration: number) {
  const formatter = new Intl.DateTimeFormat('de', {
    timeStyle: 'medium'
  });

  const d = new Date();

  d.setHours(0);
  d.setSeconds(0);
  d.setMinutes(duration);

  return formatter.format(d);
}
