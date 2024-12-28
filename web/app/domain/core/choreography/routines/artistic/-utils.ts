export function toIntlNamespace(name: string) {
  return name.replaceAll('-', '.').replace('artistic', 'judging-system-2019');
}

export function toIntlNameKey(name: string) {
  return `${toIntlNamespace(name)}.name`;
}

export function toIntlIntervalKey(name: string, interval: number) {
  return `${toIntlNamespace(name)}.interval.${interval.toString()}`;
}
