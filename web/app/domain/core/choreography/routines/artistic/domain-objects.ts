export type Scoring = 'average' | 'sum';

export interface JudgingSystemCriterionInterval {
  marker: number;
  expression: string;
}

// --

export interface JudgingSystemCriterionDescriptor {
  name: string;
  intervals: JudgingSystemCriterionInterval[];
}

export interface JudgingSystemCategoryDescriptor {
  name: string;
  scoring: Scoring;
  criteria: JudgingSystemCriterionDescriptor[];
}

export interface JudgingSystemPartDescriptor {
  name: string;
  scoring: Scoring;
  categories: JudgingSystemCategoryDescriptor[];
}

export interface JudgingSystemDescriptor {
  name: string;
  scoring: Scoring;
  parts: JudgingSystemPartDescriptor[];
}

// --

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

export interface WireJudgingSystemResults {
  name: string;
  parts: WirePartResult[];
}

// --

export interface JudgingSystemCriterion
  extends JudgingSystemCriterionDescriptor,
    WireCriterionResult {
  intervals: JudgingSystemCriterionInterval[];
  category: JudgingSystemCategory;
}

export interface JudgingSystemCategory extends JudgingSystemCategoryDescriptor, WireCategoryResult {
  criteria: JudgingSystemCriterion[];
  part: JudgingSystemPart;
}

export interface JudgingSystemPart extends JudgingSystemPartDescriptor, WirePartResult {
  categories: JudgingSystemCategory[];
  system: JudgingSystem;
}

export interface JudgingSystem extends JudgingSystemDescriptor, WireJudgingSystemResults {
  parts: JudgingSystemPart[];
}

// ---

export interface CategoryResult {
  name: string;
  scoring: Scoring;
  criteria: WireCriterionResult[];
}

export interface PartResult {
  name: string;
  scoring: Scoring;
  categories: CategoryResult[];
}

export interface JudgingSystemResults {
  scoring: Scoring;
  parts: PartResult[];
}
