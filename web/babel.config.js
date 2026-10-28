import { buildMacros } from '@embroider/macros/babel';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { scopedCSS } from 'ember-scoped-css/babel';

const __filename = fileURLToPath(import.meta.url);

const macros = buildMacros({
  configure: (config) => {
    config.setGlobalConfig(__filename, '@embroider/core', { active: true });
  }
});

export default {
  plugins: [
    'ember-concurrency/async-arrow-task-transform',
    scopedCSS(),
    [
      '@babel/plugin-transform-typescript',
      {
        allExtensions: true,
        onlyRemoveTypeImports: true,
        allowDeclareFields: true
      }
    ],
    [
      'babel-plugin-ember-template-compilation',
      {
        compilerPath: 'ember-source/ember-template-compiler/index.js',
        transforms: [
          scopedCSS.template({
            layerName: 'app',
            additionalRoots: ['app']
          }),
          ...macros.templateMacros
        ]
      }
    ],
    [
      'module:decorator-transforms',
      {
        runtime: {
          import: fileURLToPath(import.meta.resolve('decorator-transforms/runtime-esm'))
        }
      }
    ],
    [
      '@babel/plugin-transform-runtime',
      {
        absoluteRuntime: path.dirname(__filename),
        useESModules: true,
        regenerator: false
      }
    ],
    ...macros.babelMacros
  ],

  generatorOpts: {
    compact: false
  }
};
