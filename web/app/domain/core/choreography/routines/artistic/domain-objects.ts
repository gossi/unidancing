import type { JudgingSystemID } from '../systems/domain-objects';

export interface WireCriterionResult {
  name: string;
  value: number;
}

export interface WireCategoryResult {
  name: string;
  criteria: WireCriterionResult[];
}

export interface WirePartResult {
  name: string;
  categories: WireCategoryResult[];
}

export interface WireArtisticResults {
  name: JudgingSystemID;
  parts: WirePartResult[];
}

// ---

export type CriterionResult = WireCriterionResult;

export interface CategoryResult extends WireCategoryResult {
  score: number;
  criteria: CriterionResult[];
}

export interface PartResult extends WirePartResult {
  score: number;
  categories: CategoryResult[];
}

export interface ArtisticResults extends WireArtisticResults {
  score: number;
  parts: PartResult[];
}
