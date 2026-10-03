import type Owner from '@ember/owner';

type Fn = () => unknown;

export const cacheResult = async <F extends Fn>(
  key: string,
  owner: Owner,
  fn: F
): Promise<Awaited<ReturnType<F>>> => {
  const cache = owner.lookup('service:app-data-cache');

  const id = key.replaceAll('/', '-');
  const cached = cache?.retrieve<Awaited<ReturnType<F>>>(id);

  if (cached) {
    return cached;
  }

  const promise = (async () => {
    const data = await fn();

    cache?.put(id, data);

    return data;
  })();

  return (await cache?.track(promise)) ?? promise;
};
