import '@formatjs/intl-durationformat/polyfill';

import { settled as emberSettled } from '@ember/test-helpers';

import { setSSRMode } from './domain/supporting/utils';
import { drainPending } from './services/app-data-cache';

import Application from './app';
import config from './config/environment';

// Marks the app as server-rendering: data fetches are awaited by the
// renderer and their results are serialized into a JSON data island in
// <head> (see services/app-data-cache.ts).
setSSRMode(true);

// The SSR environment installs a curated set of browser globals from the
// happy-dom window. Addon code (e.g. ember-aria-voyager) references element
// subclasses like HTMLHRElement as bare globals — backfill any HTML* classes
// the app graph may touch.
const globalScope = globalThis as unknown as Record<string, unknown>;
const win = globalScope.window as Record<string, unknown> | undefined;

if (win) {
  for (const key of Object.getOwnPropertyNames(win)) {
    if (key.startsWith('HTML') && globalScope[key] === undefined) {
      try {
        globalScope[key] = win[key];
      } catch {
        // non-writable globals are already present
      }
    }
  }
}

export function createSsrApp() {
  return Application.create({
    ...config.APP,
    autoboot: false
  });
}

/**
 * Awaits pending data fetches (registered by `cacheResult`) and Ember
 * re-render cycles, so the captured DOM contains resolved content rather
 * than loading states.
 */
export async function settled(): Promise<void> {
  await emberSettled();
  await drainPending();
  await emberSettled();
  // route activation after data arrival may schedule follow-up fetches
  await drainPending();
  await emberSettled();
}
