import { getIcon } from '../components/icon';

import type { Icons } from '../components/icon';
import type { Personal } from '../database/exercises';

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

const DEFAULT = { icon: true, text: false };

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
