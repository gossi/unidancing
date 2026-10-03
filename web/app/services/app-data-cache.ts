import Service from '@ember/service';

import { isSSR } from '@unidancing/app/domain/supporting/utils';

const ISLAND_ID = 'unidancing-data';

/**
 * Module-scoped registry of in-flight data promises (only populated during
 * server rendering). The SSG entry drains this before capturing the DOM,
 * replacing FastBoot's `deferRendering()`.
 *
 * Safe as a module global because the SSG worker renders sequentially.
 */
const pending = new Set<Promise<unknown>>();

export async function drainPending(): Promise<void> {
  while (pending.size > 0) {
    await Promise.allSettled(Array.from(pending));
  }
}

/**
 * Replaces the `fastboot.shoebox` for build-time (SSG) data:
 *
 * - During server rendering, `put()` stores per-render values and serializes
 *   them into a JSON data island in `document.head`, which becomes part of
 *   the prerendered HTML.
 * - On the client, `retrieve()` lazily loads that island once, so content
 *   fetched at build time is not re-fetched at boot (the content API is only
 *   reachable during the build).
 */
export default class AppDataCacheService extends Service {
  #data = new Map<string, unknown>();
  #islandLoaded = false;

  track<T>(promise: Promise<T>): Promise<T> {
    if (!isSSR()) {
      return promise;
    }

    pending.add(promise);

    const cleanup = () => {
      pending.delete(promise);
    };

    void promise.then(cleanup, cleanup);

    return promise;
  }

  retrieve<T>(key: string): T | undefined {
    if (!this.#islandLoaded && !isSSR()) {
      this.#islandLoaded = true;
      this.#loadIsland();
    }

    return this.#data.get(key) as T | undefined;
  }

  put(key: string, value: unknown): void {
    this.#data.set(key, value);

    if (isSSR()) {
      this.#writeIsland();
    }
  }

  #loadIsland(): void {
    const node = document.getElementById(ISLAND_ID);

    if (!node?.textContent) {
      return;
    }

    try {
      const entries = JSON.parse(node.textContent) as Record<string, unknown>;

      for (const [key, value] of Object.entries(entries)) {
        this.#data.set(key, value);
      }
    } catch {
      // a corrupt island is treated as empty
    }
  }

  #writeIsland(): void {
    // The SSG worker reuses one document across renders: drop any island left
    // over from a previous render so each page only embeds its own data.
    document.getElementById(ISLAND_ID)?.remove();

    const script = document.createElement('script');

    script.type = 'application/json';
    script.id = ISLAND_ID;
    script.textContent = JSON.stringify(Object.fromEntries(this.#data)).replace(
      /<\/(script)/gi,
      '<\\/$1'
    );

    document.head.append(script);
  }
}

declare module '@ember/service' {
  interface Registry {
    'app-data-cache': AppDataCacheService;
  }
}
