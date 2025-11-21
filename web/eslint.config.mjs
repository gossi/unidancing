import { fileURLToPath } from 'node:url';

import { includeIgnoreFile } from '@eslint/compat';
import { defineConfig } from 'eslint/config';

import ember from '@gossi/config-eslint/ember';

const gitignorePath = fileURLToPath(new URL('.gitignore', import.meta.url));

export default defineConfig([
  includeIgnoreFile(gitignorePath, 'Imported .gitignore patterns'),
  {
    // your overrides
  },
  ...ember(import.meta.dirname),
  {
    rules: {
      'unicorn/consistent-function-scoping': 'off'
    }
  }
]);
