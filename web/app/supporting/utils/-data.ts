import { sweetenOwner } from 'ember-sweet-owner';

import type Owner from '@ember/owner';

type Fn = () => unknown;

export const cacheResult = async <F extends Fn>(
  key: string,
  owner: Owner,
  fn: F
): Promise<Awaited<ReturnType<F>>> => {
  const { services } = sweetenOwner(owner);
  const { fastboot } = services;

  const cached = fastboot.shoebox.retrieve(key);

  if (cached) {
    return cached as Awaited<ReturnType<F>>;
  }

  const data = await fn();

  if (fastboot.isFastBoot) {
    fastboot.shoebox.put(key, data);
  }

  return data as Awaited<ReturnType<F>>;
};
