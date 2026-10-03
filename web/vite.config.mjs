import { fileURLToPath } from 'node:url';

import { loadTranslations } from '@ember-intl/vite';
import { babel } from '@rollup/plugin-babel';
import { ember, extensions } from '@embroider/vite';
import { theemo } from '@theemo/vite';
import { defineConfig } from 'vite';

export default defineConfig({
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
    loadTranslations()
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
});
