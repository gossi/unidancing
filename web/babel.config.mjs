import { buildMacros } from '@embroider/macros/babel';
import { dirname } from 'node:path';
import { fileURLToPath } from 'node:url';

const __filename = fileURLToPath(import.meta.url);

const macros = buildMacros({
  configure: (config) => {
    config.setGlobalConfig(__filename, '@embroider/core', { active: true });
    config.setConfig(__filename, 'ember-qunit', { theme: 'ember' });
  }
});

export default {
  plugins: [
    'ember-concurrency/async-arrow-task-transform',
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
        transforms: [...macros.templateMacros]
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
        absoluteRuntime: dirname(__filename),
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
