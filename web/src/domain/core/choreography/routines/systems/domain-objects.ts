export type JudgingSystemID = 'iuf-performance-2019';
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
  name: JudgingSystemID;
  scoring: Scoring;
  parts: JudgingSystemPartDescriptor[];
}

// --

export interface JudgingSystemCriterion extends JudgingSystemCriterionDescriptor {
  intervals: JudgingSystemCriterionInterval[];
  category: JudgingSystemCategory;
  value: number;
}

export interface JudgingSystemCategory extends JudgingSystemCategoryDescriptor {
  criteria: JudgingSystemCriterion[];
  part: JudgingSystemPart;
}

export interface JudgingSystemPart extends JudgingSystemPartDescriptor {
  categories: JudgingSystemCategory[];
  system: JudgingSystem;
}

export interface JudgingSystem extends JudgingSystemDescriptor {
  parts: JudgingSystemPart[];
}

// --
