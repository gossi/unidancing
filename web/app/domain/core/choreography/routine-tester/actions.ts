import type { CategoryResult, JudgingSystemResults, PartResult, Scoring } from './domain-objects';

export function score(values: number[], scoring: Scoring) {
  const sum = values.reduce((initial, current) => initial + current, 0);

  if (scoring === 'average') {
    return sum / values.length;
  }

  return sum;
}

export function scoreCategory(data: CategoryResult) {
  const values = data.criteria.map((c) => c.value);

  return score(values, data.scoring);
}

export function scorePart(data: PartResult) {
  const values = data.categories.map((c) => scoreCategory(c));

  return score(values, data.scoring);
}

export function scoreSystem(data: JudgingSystemResults) {
  const values = data.parts.map((part) => scorePart(part));

  return score(values, data.scoring);
}
