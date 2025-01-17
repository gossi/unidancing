import { Temporal } from 'temporal-polyfill';

export function durationToSeconds(duration?: Temporal.Duration) {
  if (!duration) return 0;

  return duration.total('second');
}

export function secondsToDuration(duration: number) {
  let milliseconds = 0;

  if (Math.floor(duration) !== duration) {
    milliseconds = Math.floor((duration - Math.floor(duration)) * 1000);

    duration = Math.floor(duration);
  }

  const hours = Math.floor(duration / 3600);
  const minutes = Math.floor((duration - hours * 3600) / 60);
  const seconds = duration - hours * 3600 - minutes * 60;

  return Temporal.Duration.from({
    hours,
    minutes,
    seconds,
    milliseconds
  });
}

export function formatDuration(
  duration?: Temporal.Duration,
  options: Intl.DurationFormatOptions = {}
) {
  if (!duration) return;

  return new Intl.DurationFormat('en', { style: 'digital', ...options }).format(duration);
}

export function dateToSecondsWithMilli(time: Date) {
  return (time.getMinutes() * 60 * 1000 + time.getSeconds() * 1000 + time.getMilliseconds()) / 1000;
}

export function dateToMilliseconds(time: Date) {
  return time.getMinutes() * 60 * 1000 + time.getSeconds() * 1000 + time.getMilliseconds();
}

export function dateToSeconds(time: Date) {
  return time.getMinutes() * 60 + time.getSeconds();
}
