let ssrMode = false;

/**
 * Set by the SSR/SSG entry (`app/app-ssr.ts`) before rendering. Never set in
 * the browser bundle, so `isSSR()` is false during tests and normal client
 * usage, and true only while content is rendered for prerendering.
 */
function setSSRMode(value: boolean): void {
  ssrMode = value;
}

const isSSR = (): boolean => {
  return ssrMode;
};

const asString = (value: unknown): string => {
  return value as string;
};

const asNumber = (value: unknown): number => {
  return value as number;
};

const asBoolean = (value: unknown): boolean => {
  return value as boolean;
};

export { asBoolean, asNumber, asString, isSSR, setSSRMode };
