// from: https://github.com/formatjs/formatjs/blob/main/packages/intl-durationformat/src/types.ts
declare namespace Intl {
  export class DurationFormat {
    constructor(locales?: string | string[], options?: DurationFormatOptions): DurationFormat;

    resolvedOptions(): ResolvedDurationFormatOptions;

    formatToParts(duration: DurationInput): DurationFormatPart[];

    format(duration: DurationInput): string;
  }

  export type DurationFormatOptions = Partial<ResolvedDurationFormatOptions>;

  export interface ResolvedDurationFormatOptions {
    localeMatcher: 'best fit' | 'lookup';

    style: 'long' | 'short' | 'narrow' | 'digital';

    years: 'long' | 'short' | 'narrow';

    yearsDisplay: 'always' | 'auto';

    months: 'long' | 'short' | 'narrow';

    monthsDisplay: 'always' | 'auto';

    weeks: 'long' | 'short' | 'narrow';

    weeksDisplay: 'always' | 'auto';

    days: 'long' | 'short' | 'narrow';

    daysDisplay: 'always' | 'auto';

    hours: 'long' | 'short' | 'narrow' | 'numeric';

    hoursDisplay: 'always' | 'auto';

    minutes: 'long' | 'short' | 'narrow' | 'numeric' | '2-digit';

    minutesDisplay: 'always' | 'auto';

    seconds: 'long' | 'short' | 'narrow' | 'numeric' | '2-digit';

    secondsDisplay: 'always' | 'auto';

    milliseconds: 'long' | 'short' | 'narrow' | 'numeric';

    millisecondsDisplay: 'always' | 'auto';

    microseconds: 'long' | 'short' | 'narrow' | 'numeric';

    microsecondsDisplay: 'always' | 'auto';

    nanoseconds: 'long' | 'short' | 'narrow' | 'numeric';

    nanosecondsDisplay: 'always' | 'auto';

    fractionalDigits?: 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 9;

    numberingSystem: string;

    round: boolean;
  }
}
