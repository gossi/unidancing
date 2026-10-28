import { loadTranslations } from '@ember-intl/vite';
import { ember, extensions } from '@embroider/vite';
import { readFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';

import { babel } from '@rollup/plugin-babel';
import { playwright } from '@vitest/browser-playwright';
import { scopedCSS } from 'ember-scoped-css/vite';
import { FileSystemIconLoader } from 'unplugin-icons/loaders';
import icons from 'unplugin-icons/vite';
import { emberSsg } from 'vite-ember-ssr/vite-plugin';
import { defineConfig } from 'vitest/config';

import { theemo } from '@theemo/vite';

import type { UserConfig } from 'vite';

/**
 * Enumerates the routes to prerender, mirroring the content tree (Tina CMS).
 * Runs at production build time only.
 *
 * The endpoint + token are read from the generated Tina client (produced by
 * `tinacms build`), so this follows whatever environment the CMS was built
 * against (local dev server or Tina Cloud).
 */
async function findRoutes(): Promise<string[]> {
  const source = await readFile('./tina/__generated__/client.ts', 'utf8');
  const url = /url:\s*'([^']+)'/.exec(source)?.[1];

  if (!url) {
    throw new Error('Could not read Tina content URL from tina/__generated__/client.ts');
  }

  const token = /token:\s*'([^']+)'/.exec(source)?.[1];

  /**
   * Folder-aware document ids. `_sys.filename` is only the file's base name, so
   * it silently drops subfolders — routines live in `content/routines/<event>/`.
   * The app links to documents with `_sys.relativePath` minus its extension
   * (see routines/analysis/routines.gts), so enumerate the same way here.
   */
  const routePaths = async (field: string, prefix: string): Promise<string[]> => {
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        ...(token && { 'X-API-KEY': token })
      },
      body: JSON.stringify({
        query: `{ ${field} { edges { node { _sys { relativePath extension } } } } }`
      })
    });

    const { data, errors } = (await response.json()) as {
      data?: Record<
        string,
        { edges: { node: { _sys: { relativePath: string; extension: string } } }[] }
      >;
      errors?: unknown;
    };

    if (!data?.[field]) {
      throw new Error(
        `Failed to query ${field} from Tina content source: ${JSON.stringify(errors)}`
      );
    }

    return data[field].edges.map(({ node }) => {
      const slug = node._sys.relativePath.slice(0, -node._sys.extension.length);

      return `${prefix}/${slug}`;
    });
  };

  const arts = await routePaths('artConnection', 'kuenste');
  const courses = await routePaths('courseConnection', 'courses');
  const exercises = await routePaths('exerciseConnection', 'uebungen');
  const moves = await routePaths('moveConnection', 'moves');
  const skills = await routePaths('skillConnection', 'fertigkeiten');
  const routines = await routePaths('routinesConnection', 'choreography/routines');

  return [
    'index',
    'kuenste',
    ...arts,
    'courses',
    ...courses,
    'fertigkeiten',
    ...skills,
    'uebungen',
    ...exercises,
    'moves',
    ...moves,
    'choreography',
    'choreography/unidance-writing',
    'choreography/routines',
    ...routines,
    'choreography/not-todo-list',
    'training',
    'training/leistungsprofil',
    'training/planning',
    'training/planning/units',
    'training/planning/assistants',
    'training/planning/games',
    'training/control',
    'training/diagnostics',
    'training/diagnostics/time-tracking',
    'training/diagnostics/body-language'
  ];
}

// the explicit return type keeps TS from widening the `test` block's browser
// literals during overload resolution of `defineConfig`
export default defineConfig(async ({ command, mode }): Promise<UserConfig> => {
  // SSG only for production builds; also skip in the plugin's internal SSR
  // child build (which would otherwise re-enumerate routes over the network).
  const prerender =
    command === 'build' && mode === 'production' && !process.env.__VITE_EMBER_SSG_CHILD__;
  const routes = prerender ? await findRoutes() : [];

  return {
    // expose .env values the app config reads (besides the default VITE_)
    envPrefix: ['VITE_', 'YOUTUBE_'],
    test: {
      include: ['tests/**/*-test.{gjs,gts,js,ts}'],
      // Ember boots one app instance per test file in a single browser tab;
      // keep runs serial (see ember-vitest setup guide).
      maxConcurrency: 1,
      browser: {
        enabled: true,
        headless: true,
        provider: playwright(),
        instances: [{ browser: 'chromium' }]
      },
      setupFiles: ['./tests/test-setup.ts']
    },
    plugins: [
      ember(),
      scopedCSS({ layerName: 'app' }),
      // extra plugins here
      babel({
        babelHelpers: 'runtime',
        extensions
      }),
      theemo({
        defaultTheme: 'unidancing'
      }),
      loadTranslations(),
      // hokulea is icon-agnostic; icons are provided through unplugin-icons
      // (Phosphor via iconify, custom SVGs from ./public/icons)
      // https://hokulea.netlify.app/?path=/story/documentation-getting-started-installation--installation
      icons({
        autoInstall: true,
        compiler: 'ember',
        customCollections: {
          custom: FileSystemIconLoader('./public/icons')
        }
      }),
      ...(prerender ? [emberSsg({ routes, shoebox: true })] : [])
    ],
    resolve: {
      alias: {
        '@/tina': fileURLToPath(new URL('tina/__generated__', import.meta.url)),
        // ember-source provides @glimmer/tracking virtually at its root specifier,
        // but older addons (ember-resources 6, statecharts) deep-import this
        // subpath, which needs to be mapped onto ember-source's own dist file.
        '@glimmer/tracking/primitives/cache':
          'ember-source/@glimmer/tracking/primitives/cache/index.js'
      }
    }
  };
});
