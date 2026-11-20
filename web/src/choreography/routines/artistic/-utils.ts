import type { JudgingSystemCriterion } from '../systems/domain-objects';

export function toIntlNamespace(name: string) {
  return name.replaceAll('-', '.').replace('artistic', 'judging-system-2019');
}

export function toIntlNameKey(name: string) {
  return `${toIntlNamespace(name)}.name`;
}

export function toIntlIntervalKey(name: string, interval: number) {
  return `${toIntlNamespace(name)}.interval.${interval.toString()}`;
}

export function getCriterionKey(criterion: JudgingSystemCriterion) {
  return `${criterion.category.part.name}.${criterion.category.name}.${criterion.name}`;
}
