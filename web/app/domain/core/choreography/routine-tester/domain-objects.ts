interface TimeTrack {
  from: number;
  to: number;
}

export interface RoutineTest {
  videoUrl?: string;
  timeTracking: {
    tricks: TimeTrack[];
    artistic: TimeTrack[];
    void: TimeTrack[];
    filler: TimeTrack[];
    faceup: TimeTrack[];
  };
}

export type Scoring = 'average' | 'sum';
// --

export interface JudgingSystemCriterion extends JudgingSystemCriterionDescriptor {
  name: string;
  intervals: Record<string, string>;
}

export interface JudgingSystemCategory {
  name: string;
  scoring: Scoring;
  criteria: JudgingSystemCriterion[];
}

export interface JudgingSystemPart {
  name: string;
  scoring: Scoring;
  categories: JudgingSystemCategory[];
}

export interface JudgingSystem {
  scoring: Scoring;
  parts: JudgingSystemPart[];
}

// ---

export interface WireCategoryResult {
  name: string;
  criteria: { name: string; value: number }[];
}

export interface WirePartResult {
  name: string;
  categories: WireCategoryResult[];
}

export interface WireJudgingSystemResults {
  parts: WirePartResult[];
}

export interface CategoryResult {
  name: string;
  scoring: Scoring;
  criteria: { name: string; value: number }[];
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
