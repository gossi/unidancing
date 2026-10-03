import { readFile } from 'node:fs/promises';
import { fileURLToPath } from 'node:url';

import { loadTranslations } from '@ember-intl/vite';
import { babel } from '@rollup/plugin-babel';
import { ember, extensions } from '@embroider/vite';
import { theemo } from '@theemo/vite';
import { FileSystemIconLoader } from 'unplugin-icons/loaders';
import icons from 'unplugin-icons/vite';
import { emberSsg } from 'vite-ember-ssr/vite-plugin';
import { defineConfig } from 'vite';

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
  const url = source.match(/url:\s*'([^']+)'/)?.[1];
  const token = source.match(/token:\s*'([^']+)'/)?.[1];

  if (!url) {
    throw new Error('Could not read Tina content URL from tina/__generated__/client.ts');
  }

  const filenames = async (field: string): Promise<string[]> => {
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        ...(token ? { 'X-API-KEY': token } : {})
      },
      body: JSON.stringify({
        query: `{ ${field} { edges { node { _sys { filename } } } } }`
      })
    });

    const { data, errors } = (await response.json()) as {
      data?: Record<string, { edges: { node: { _sys: { filename: string } } }[] }>;
      errors?: unknown;
    };

    if (!data?.[field]) {
      throw new Error(`Failed to query ${field} from Tina content source: ${JSON.stringify(errors)}`);
    }

    return data[field].edges.map(({ node }) => node._sys.filename);
  };

  const arts = (await filenames('artConnection')).map((f) => `kuenste/${f}`);
  const courses = (await filenames('courseConnection')).map((f) => `courses/${f}`);
  const exercises = (await filenames('exerciseConnection')).map((f) => `uebungen/${f}`);
  const moves = (await filenames('moveConnection')).map((f) => `moves/${f}`);
  const skills = (await filenames('skillConnection')).map((f) => `fertigkeiten/${f}`);

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
    'choreography/not-todo-list',
    'training',
    'training/planning',
    'training/planning/assistants',
    'training/planning/games',
    'training/control',
    'training/diagnostics',
    'training/diagnostics/time-tracking',
    'training/diagnostics/body-language'
  ];
}

export default defineConfig(async ({ command, mode }) => {
  // SSG only for production builds; also skip in the plugin's internal SSR
  // child build (which would otherwise re-enumerate routes over the network).
  const prerender =
    command === 'build' && mode === 'production' && !process.env.__VITE_EMBER_SSG_CHILD__;
  const routes = prerender ? await findRoutes() : [];

  return {
    // expose .env values the app config reads (besides the default VITE_)
    envPrefix: ['VITE_', 'YOUTUBE_'],
    plugins: [
      ember(),
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
        '@/tina': fileURLToPath(new URL('./tina/__generated__', import.meta.url)),
        // ember-source provides @glimmer/tracking virtually at its root specifier,
        // but older addons (ember-resources 6, statecharts) deep-import this
        // subpath, which needs to be mapped onto ember-source's own dist file.
        '@glimmer/tracking/primitives/cache': 'ember-source/@glimmer/tracking/primitives/cache/index.js'
      }
    }
  };
});
