const Category = {
  Artistry: 'artistry',
  Communication: 'communication',
  Tricks: 'tricks',
  Filler: 'filler',
  Void: 'void'
} as const;

type Category = (typeof Category)[keyof typeof Category];

export const groups = [
  {
    id: Category.Artistry,
    content: 'Artistik',
    className: Category.Artistry,
    key: 'a'
  },
  {
    id: Category.Communication,
    content: 'Kommunikation',
    className: Category.Communication,
    key: 'c'
  },
  {
    id: Category.Tricks,
    content: 'Tricks',
    className: Category.Tricks,
    key: 't'
  },
  {
    id: Category.Filler,
    content: 'Filler',
    className: Category.Filler,
    key: 'f'
  },
  {
    id: Category.Void,
    content: 'Void',
    className: Category.Void,
    key: 'v'
  },
  {
    id: 'marker',
    content: 'Marker',
    className: 'marker'
  }
];

export interface Scene {
  start: number;
  end: number;
  category: (typeof Category)[keyof typeof Category];
}

export interface TimeTracking {
  start?: number;
  end?: number;
  scenes?: Scene[];
}

export interface TimeTrackingFormData {
  timeTracking: TimeTracking;
}

export interface WireTimeTracking {
  start: number;
  end: number;
  scenes: Scene[];
}

export interface TimeTrackingDuration {
  artistry?: number;
  tricks?: number;
  void?: number;
  filler?: number;
  communication?: number;
}

export interface TimeTrackingRatio {
  artistry?: number;
  tricks?: number;
  void?: number;
  filler?: number;
  communication?: number;
}

interface EvaluationPoint {
  duration: number;
  ratio: number;
}

export interface TimeTrackingGroupsEvaluation {
  artistry?: EvaluationPoint;
  tricks?: EvaluationPoint;
  void?: EvaluationPoint;
  filler?: EvaluationPoint;
  communication?: EvaluationPoint;
}

export interface TimeTrackingEvaluation {
  duration: number;

  evaluation: TimeTrackingGroupsEvaluation;
}

export type TimeAnalysis = WireTimeTracking & TimeTrackingEvaluation;

export function validateTimeTracking(data: TimeTracking): string[] | undefined {
  const errors = [];

  const scenesPresent = (data.scenes ?? []).length > 0;

  if (scenesPresent) {
    if (!data.start) {
      errors.push('Start ist noch nicht markiert');
    }

    if (!data.end) {
      errors.push('Ende ist noch nicht markiert');
    }
  }

  if (errors.length > 0) {
    return errors;
  }

  return undefined;
}

export function evaluateTimeTracking(data: WireTimeTracking): TimeTrackingEvaluation {
  const duration = data.end - data.start;

  const evaluation = Object.fromEntries(
    Object.entries(Object.groupBy(data.scenes, ({ category }) => category)).map(([k, points]) => {
      const dur = Math.round(points.reduce((acc, d) => acc + (d.end - d.start), 0) * 1000) / 1000;
      const ratio = Math.round((dur / duration) * 10000) / 10000;

      return [k, { duration: dur, ratio }];
    })
  ) as unknown as TimeTrackingGroupsEvaluation;

  return {
    duration,
    evaluation
  };
}
