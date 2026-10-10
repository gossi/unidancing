import { fileURLToPath } from 'node:url';

import { includeIgnoreFile } from '@eslint/compat';
import { defineConfig } from 'eslint/config';

import ember from '@gossi/config-eslint/ember';

const gitignorePath = fileURLToPath(new URL('.gitignore', import.meta.url));

export default defineConfig([
  includeIgnoreFile(gitignorePath, 'Imported .gitignore patterns'),
  {
    ignores: ['public/admin', 'types', 'tina']
  },
  ...ember(import.meta.dirname),
  {
    rules: {
      'unicorn/consistent-function-scoping': 'off',
      'unicorn/consistent-class-member-order': 'off',
      // Both rules rewrite `if (obj[key])` existence checks to
      // `Object.hasOwn(obj, key)` — which throws on Glimmer's NamedArgsProxy
      // (no real property descriptors; see getParam in dance-oh-mat/dance-mix)
      // and changes truthiness semantics (null/0-valued entries slip through).
      'prefer-object-has-own': 'off',
      'unicorn/no-computed-property-existence-check': 'off'
    }
  }
]);
