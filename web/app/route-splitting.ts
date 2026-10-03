/**
 * Route-based code splitting for the compatless Embroider build.
 *
 * Ember 4's `splitAtRoutes` option is compat-only. In strict mode the
 * mechanism is explicit: the route files are excluded from the eager module
 * registration in `app.ts` and registered as lazy bundles that
 * `@embroider/router` loads on transition (and that the SSR renderer awaits
 * during prerendering).
 */

declare global {
  interface Window {
    _embroiderRouteBundles_: Array<{
      names: string[];
      load: () => Promise<{ default: Record<string, unknown> }>;
    }>;
  }
}

type Entries = Array<[name: string, loader: () => Promise<{ default: unknown }>]>;

export function routeBundle(entries: Entries) {
  return {
    names: entries.map(([name]) => name),
    load: async () => {
      const modules: Record<string, unknown> = {};

      await Promise.all(
        entries.map(async ([name, loader]) => {
          const mod = await loader();
          modules[`./routes/${name.replaceAll('.', '/')}`] = mod.default;
        })
      );

      return { default: modules };
    }
  };
}

window._embroiderRouteBundles_ = [
  routeBundle([
    ['courses', () => import('./routes/courses.gts')],
    ['courses.index', () => import('./routes/courses/index.gts')],
    ['courses.details', () => import('./routes/courses/details.gts')]
  ]),
  routeBundle([
    ['skills', () => import('./routes/skills/index.gts')],
    ['skills.index', () => import('./routes/skills/index.gts')],
    ['skills.details', () => import('./routes/skills/details.gts')]
  ]),
  routeBundle([
    ['exercises', () => import('./routes/exercises/index.gts')],
    ['exercises.index', () => import('./routes/exercises/index.gts')],
    ['exercises.details', () => import('./routes/exercises/details.gts')]
  ]),
  routeBundle([
    ['moves', () => import('./routes/moves/index.gts')],
    ['moves.index', () => import('./routes/moves/index.gts')],
    ['moves.details', () => import('./routes/moves/details.gts')]
  ]),
  routeBundle([
    ['choreography', () => import('./routes/choreography.gts')],
    ['choreography.index', () => import('./routes/choreography/index.gts')],
    ['choreography.not-todo-list', () => import('./routes/choreography/not-todo-list.gts')],
    ['choreography.unidance-writing', () => import('./routes/choreography/unidance-writing.gts')],
    ['choreography.routines', () => import('./routes/choreography/routines.gts')],
    ['choreography.routines.index', () => import('./routes/choreography/routines/index.gts')],
    ['choreography.routines.test', () => import('./routes/choreography/routines/test.gts')],
    ['choreography.routines.test.index', () => import('./routes/choreography/routines/test/index.gts')],
    ['choreography.routines.test_load', () => import('./routes/choreography/routines/test_load.gts')],
    ['choreography.routines.results', () => import('./routes/choreography/routines/results.gts')],
    ['choreography.routines.details', () => import('./routes/choreography/routines/details.gts')],
    ['choreography.routines.training.index', () => import('./routes/choreography/routines/training/index.gts')],
    ['choreography.routines.training.results', () =>
      import('./routes/choreography/routines/training/results.gts')]
  ]),
  routeBundle([
    ['training', () => import('./routes/training.gts')],
    ['training.index', () => import('./routes/training/index.gts')],
    ['training.athletic-profile', () => import('./routes/training/athletic-profile.gts')],
    ['training.control', () => import('./routes/training/control.gts')],
    ['training.planning', () => import('./routes/training/planning.gts')],
    ['training.planning.index', () => import('./routes/training/planning/index.gts')],
    ['training.planning.units', () => import('./routes/training/planning/units.gts')],
    ['training.planning.plans', () => import('./routes/training/planning/plans.gts')],
    ['training.planning.assistants', () => import('./routes/training/planning/assistants.gts')],
    ['training.planning.games', () => import('./routes/training/planning/games.gts')],
    ['training.diagnostics', () => import('./routes/training/diagnostics.gts')],
    ['training.diagnostics.index', () => import('./routes/training/diagnostics/index.gts')],
    ['training.diagnostics.time-tracking', () =>
      import('./routes/training/diagnostics/time-tracking.gts')],
    ['training.diagnostics.body-language', () =>
      import('./routes/training/diagnostics/body-language.gts')]
  ])
];
