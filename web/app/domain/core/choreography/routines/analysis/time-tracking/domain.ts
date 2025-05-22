const Category = {
  Artistry: 'artistry',
  Communication: 'communication',
  Tricks: 'tricks',
  Filler: 'filler',
  Void: 'void',
  Dismounts: 'dismounts'
} as const;

type Category = (typeof Category)[keyof typeof Category];

export const Attractivity = {
  Attractor: 'attractor',
  Detractor: 'detractor'
} as const;

export type Attractivity = (typeof Attractivity)[keyof typeof Attractivity];

export type CategoryGroup = {
  id: Category;
  content: string;
  className: string;
  key: string;
  attractivity: Attractivity;
};

export type Marker = {
  id: 'marker';
  content: string;
  className: string;
};

export type AllGroups = CategoryGroup | Marker;

export const CATEGORY_GROUPS: CategoryGroup[] = [
  {
    id: Category.Artistry,
    content: 'Artistik',
    className: Category.Artistry,
    key: 'a',
    attractivity: Attractivity.Attractor
  },
  {
    id: Category.Communication,
    content: 'Kommunikation',
    className: Category.Communication,
    key: 'c',
    attractivity: Attractivity.Attractor
  },
  {
    id: Category.Tricks,
    content: 'Tricks',
    className: Category.Tricks,
    key: 't',
    attractivity: Attractivity.Attractor
  },
  {
    id: Category.Filler,
    content: 'Filler',
    className: Category.Filler,
    key: 'f',
    attractivity: Attractivity.Detractor
  },
  {
    id: Category.Void,
    content: 'Void',
    className: Category.Void,
    key: 'v',
    attractivity: Attractivity.Detractor
  },
  {
    id: Category.Dismounts,
    content: 'Abstiege',
    className: Category.Dismounts,
    key: 'd',
    attractivity: Attractivity.Detractor
  }
];

export const GROUPS: AllGroups[] = [
  ...CATEGORY_GROUPS,
  {
    id: 'marker',
    content: 'Marker',
    className: 'marker'
  }
];

export const ARTISTIC_CATEGORIES: Category[] = [Category.Artistry, Category.Communication];
export const TECHNICAL_CATEGORIES: Category[] = [Category.Tricks, Category.Filler];

const ARTISTIC_GROUPS = CATEGORY_GROUPS.filter((g) => ARTISTIC_CATEGORIES.includes(g.id));
const TECHNICAL_GROUPS = CATEGORY_GROUPS.filter((g) => TECHNICAL_CATEGORIES.includes(g.id));

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

export interface EvaluationPoint {
  duration: number;
  ratio: number;
}

export interface TimeTrackingGroupsEvaluation {
  artistry?: EvaluationPoint;
  tricks?: EvaluationPoint;
  void?: EvaluationPoint;
  filler?: EvaluationPoint;
  communication?: EvaluationPoint;
  dismounts?: EvaluationPoint;
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

export type Effectivity = {
  duration: number;
  ratio: number;
  groups: (CategoryGroup & { value: number })[];
};

export function calculateEffectiveness(data: TimeAnalysis, groups = CATEGORY_GROUPS): Effectivity {
  let duration = 0;
  const effectiveGroups = [];

  for (const group of groups) {
    if (data.evaluation[group.id as keyof TimeTrackingGroupsEvaluation]) {
      const value =
        (data.evaluation[group.id as keyof TimeTrackingGroupsEvaluation] as EvaluationPoint)
          .duration * (group.attractivity === Attractivity.Attractor ? 1 : -1);

      duration += value;

      effectiveGroups.push({
        ...group,
        value
      });
    }
  }

  const ratio = Math.round((duration / data.duration) * 10000) / 10000;

  return {
    duration,
    ratio,
    groups: effectiveGroups
  };
}

export type Balance = {
  artistry: Effectivity & {
    relative: number;
  };
  technical: Effectivity & {
    relative: number;
  };
};

export function calculateBalance(data: TimeAnalysis): Balance {
  const artistry = calculateEffectiveness(data, ARTISTIC_GROUPS);
  const technical = calculateEffectiveness(data, TECHNICAL_GROUPS);

  return {
    artistry: {
      ...artistry,
      relative: Math.round((artistry.ratio / (artistry.ratio + technical.ratio)) * 100) / 100
    },
    technical: {
      ...technical,
      relative: Math.round((technical.ratio / (artistry.ratio + technical.ratio)) * 100) / 100
    }
  };
}
