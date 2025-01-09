import { scoreCategory, scorePart, scoreSystem } from '../systems/actions';

import type { JudgingSystem } from '../systems/domain-objects';
import type { ArtisticResults, WireArtisticResults } from './domain-objects';

export function mergeResults(system: JudgingSystem, results: WireArtisticResults): JudgingSystem {
  const data = { ...system };

  for (const part of data.parts) {
    const partResults = results.parts.find((p) => p.name === part.name);

    for (const category of part.categories) {
      const categoryResults = partResults?.categories.find((c) => c.name === category.name);

      for (const criterion of category.criteria) {
        const criterionResult = categoryResults?.criteria.find(
          (cri) => cri.name === criterion.name
        );

        criterion.value = criterionResult?.value ?? 0;
      }
    }
  }

  return data;
}

export function extractArtisticWireData(results: JudgingSystem): WireArtisticResults {
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

export function scoreArtistic(
  system: JudgingSystem,
  results: WireArtisticResults
): ArtisticResults {
  const data = mergeResults(system, results);

  return {
    name: data.name,
    score: scoreSystem(data),
    parts: data.parts.map((p) => ({
      name: p.name,
      score: scorePart(p),
      categories: p.categories.map((c) => ({
        name: c.name,
        score: scoreCategory(c),
        criteria: c.criteria.map((cr) => ({
          name: cr.name,
          value: cr.value
        }))
      }))
    }))
  };
}
