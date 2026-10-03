import { fileURLToPath } from 'node:url';

import { babel } from '@rollup/plugin-babel';
import { classicEmberSupport, ember, extensions } from '@embroider/vite';
import { theemo } from '@theemo/vite';
import { defineConfig } from 'vite';

export default defineConfig({
  plugins: [
    classicEmberSupport(),
    ember(),
    // extra plugins here
    babel({
      babelHelpers: 'runtime',
      extensions
    }),
    theemo({
      defaultTheme: 'unidancing'
    })
  ],
  resolve: {
    alias: {
      '@/tina': fileURLToPath(new URL('./tina/__generated__', import.meta.url))
    }
  }
});
