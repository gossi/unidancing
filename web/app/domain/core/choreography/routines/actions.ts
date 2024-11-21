import { evaluate } from 'mathjs';

import type {
  JudgingSystem,
  JudgingSystemCategory,
  JudgingSystemCriterion,
  JudgingSystemDescriptor,
  JudgingSystemPart,
  Scoring,
  WireJudgingSystemResults
} from './domain-objects';

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

export function getCriterionKey(criterion: JudgingSystemCriterion) {
  return `${criterion.category.part.name}.${criterion.category.name}.${criterion.name}`;
}

export function findInterval(criterion: JudgingSystemCriterion) {
  for (const int of criterion.intervals) {
    if (evaluate(int.expression, { x: criterion.value })) {
      return int;
    }
  }

  return undefined;
}

export function loadSystem(
  desc: JudgingSystemDescriptor,
  results?: WireJudgingSystemResults
): JudgingSystem {
  const system = {
    ...desc
  };

  system.parts = system.parts.map((p) => {
    const partResults = results?.parts.find((pr) => pr.name === p.name);

    const part = {
      ...p,
      system
    };

    part.categories = part.categories.map((c) => {
      const categoryResults = partResults?.categories.find((cr) => cr.name === c.name);
      const category = {
        ...c,
        part
      };

      category.criteria = category.criteria.map((ci) => {
        const criterionResult = categoryResults?.criteria.find((cir) => cir.name === ci.name);

        return {
          ...ci,
          value: criterionResult?.value ?? 0,
          category
        };
      });

      return category as JudgingSystemCategory;
    });

    return part as JudgingSystemPart;
  });

  return system as JudgingSystem;
}

export function extractWireData(results: JudgingSystem): WireJudgingSystemResults {
  return {
    name: results.name,
    parts: results.parts.map((p) => ({
      name: p.name,
      categories: p.categories.map((c) => ({
        name: c.name,
        criteria: c.criteria.map((cr) => ({
          name: cr.name,
          value: cr.value
        }))
      }))
    }))
  };
}
