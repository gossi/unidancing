const asString = (value: unknown): string => {
  return value as string;
};

const asNumber = (value: unknown): number => {
  return value as number;
};

const asBoolean = (value: unknown): boolean => {
  return value as boolean;
};

const isSSR = () => {
  // @ts-expect-error accessing global
  return typeof FastBoot !== 'undefined';
};

export { asBoolean, asNumber, asString, isSSR };
