type Datapoint = [number, number];

export const groups = [
  {
    id: 'artistry',
    content: 'Artistik',
    className: 'artistry',
    key: 'a'
  },
  {
    id: 'comm',
    content: 'Kommunikation',
    className: 'comm',
    key: 'c'
  },
  {
    id: 'tricks',
    content: 'Tricks',
    className: 'tricks',
    key: 't'
  },
  {
    id: 'filler',
    content: 'Filler',
    className: 'filler',
    key: 'f'
  },
  {
    id: 'void',
    content: 'Void',
    className: 'void',
    key: 'v'
  },
  {
    id: 'marker',
    content: 'Marker',
    className: 'marker'
  }
];

export interface TimeTracking {
  start?: number;
  end?: number;

  groups?: {
    artistry?: Datapoint[];
    tricks?: Datapoint[];
    void?: Datapoint[];
    filler?: Datapoint[];
    communication?: Datapoint[];
  };
}

export interface TimeTrackingFormData {
  timeTracking: TimeTracking;
}

export interface WireTimeTracking {
  start: number;
  end: number;

  groups: Partial<{
    artistry: Datapoint[];
    tricks: Datapoint[];
    void: Datapoint[];
    filler: Datapoint[];
    communication: Datapoint[];
  }>;
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
  // durations: TimeTrackingDuration;
  // ratio: TimeTrackingRatio;

  evaluation: TimeTrackingGroupsEvaluation;
}

export type TimeAnalysis = WireTimeTracking & TimeTrackingEvaluation;

export function validateTimeTracking(data: TimeTracking): string[] | undefined {
  const errors = [];

  const scenesPresent = Object.values(data.groups ?? {}).some((points) => points.length > 0);

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

  // const durations = Object.fromEntries(
  //   Object.entries(data.groups).map(([k, points]) => {
  //     return [k, points.reduce((acc, [start, end]) => acc + (end - start), 0)];
  //   })
  // ) as unknown as TimeTrackingDuration;

  // const ratio = Object.fromEntries(
  //   Object.entries(durations)
  //     // .filter(([k]) => k !== 'communication')
  //     .map(([k, v]) => [k, Math.round(v / duration)])
  // ) as unknown as TimeTrackingRatio;

  const evaluation = Object.fromEntries(
    Object.entries(data.groups).map(([k, points]) => {
      const dur = points.reduce((acc, [start, end]) => acc + (end - start), 0);
      const ratio = dur / duration;

      return [k, { duration: dur, ratio }];
    })
  ) as unknown as TimeTrackingGroupsEvaluation;

  return {
    duration,
    evaluation
    // durations,
    // ratio
  };
}
