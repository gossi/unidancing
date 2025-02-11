import { evaluate } from 'mathjs';

import { IUF_PERFORMANCE_2019 } from './data/iuf-performance-2019';

import type {
  JudgingSystem,
  JudgingSystemCategory,
  JudgingSystemCriterion,
  JudgingSystemCriterionInterval,
  JudgingSystemDescriptor,
  JudgingSystemID,
  JudgingSystemPart,
  Scoring
} from './domain-objects';

export function loadSystemDescriptor(_id: JudgingSystemID) {
  return IUF_PERFORMANCE_2019;
}

export function loadSystem(desc: JudgingSystemDescriptor): JudgingSystem {
  const system = {
    ...desc
  };

  system.parts = system.parts.map((p) => {
    const part = {
      ...p,
      system
    };

    part.categories = part.categories.map((c) => {
      const category = {
        ...c,
        part
      };

      category.criteria = category.criteria.map((ci) => {
        return {
          ...ci,
          value: 0,
          category
        } as JudgingSystemCriterion;
      });

      return category as JudgingSystemCategory;
    });

    return part as JudgingSystemPart;
  });

  return system as JudgingSystem;
}

export function score(values: number[], scoring: Scoring) {
  const sum = values.reduce((initial, current) => initial + current, 0);

  if (scoring === 'average') {
    return sum / values.length;
  }

  return sum;
}

export function scoreCategory(data: JudgingSystemCategory) {
  const values = data.criteria.map((c) => c.value);

  return score(values, data.scoring);
}

export function scorePart(data: JudgingSystemPart) {
  const values = data.categories.map((c) => scoreCategory(c));

  return score(values, data.scoring);
}

export function scoreSystem(data: JudgingSystem) {
  const values = data.parts.map((part) => scorePart(part));

  return score(values, data.scoring);
}

export function findInterval(intervals: JudgingSystemCriterionInterval[], value: number) {
  for (const int of intervals) {
    if (evaluate(int.expression, { x: value })) {
      return int;
    }
  }

  return undefined;
}
