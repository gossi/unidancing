// Ambient types for the Matomo tracking global (`window._paq`).
//
// Before `matomo.js` loads, `_paq` is a plain array of command tuples
// (see https://developer.matomo.org/api-reference/tracking-javascript);
// afterwards matomo.js replaces it with an executing proxy that keeps the
// same `push()` interface. Modeling it as an array covers the init pattern
// `window._paq = window._paq || []` used by the official snippet.

type MatomoCommandArg = string | number | boolean | null | undefined;

type MatomoCommand =
  | [command: string, ...args: MatomoCommandArg[]]
  | [callback: (this: unknown) => void, ...args: unknown[]];

declare global {
  interface Window {
    _paq?: MatomoCommand[];
  }

  // makes `globalThis._paq` type-check, incl. the `|| []` init pattern
  var _paq: MatomoCommand[] | undefined;
}

export {};
