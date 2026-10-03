import IconFootprints from '~icons/ph/footprints';
import IconUser from '~icons/ph/user';
import IconUsers from '~icons/ph/users';
import IconUsersThree from '~icons/ph/users-three';
import IconUnicycle from '~icons/custom/unicycle';

import type { Locomotion, Personal } from './domain-objects';

const LocomotionIcon = {
  pedes: IconFootprints,
  unicycle: IconUnicycle
} as const;

const PersonalIcon = {
  individual: IconUser,
  pair: IconUsers,
  group: IconUsersThree
} as const;

export function getLocomotionIcon(locomotion: Locomotion) {
  return LocomotionIcon[locomotion];
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
  return PersonalIcon[personal];
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
  lecture: {
    label: 'Trainervortrag',
    abbr: 'TV'
  },
  individual: {
    label: 'Einzelübung',
    abbr: 'Einzel'
  },
  pair: {
    label: 'Partnerübung',
    abbr: 'Partner'
  },
  group: {
    label: 'Gruppenübung',
    abbr: 'Gruppe'
  },
  discussion: {
    label: 'Diskussion',
    abbr: 'Disc'
  },
  showcase: {
    label: 'Showcase',
    abbr: 'SC'
  },
  // eslint-disable-next-line @typescript-eslint/naming-convention
  'frontal-teaching': {
    label: 'Frontalunterricht',
    abbr: 'FU'
  }
} as const;

export function formatMethod(method: keyof typeof METHOD) {
  return METHOD[method].label;
}

export function formatMethodAbbr(method: keyof typeof METHOD) {
  return METHOD[method].abbr;
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

export function asMethod(method: string) {
  return method as keyof typeof METHOD;
}
