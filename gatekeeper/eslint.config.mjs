import { fileURLToPath } from 'node:url';

import { includeIgnoreFile } from '@eslint/compat';
import { defineConfig } from 'eslint/config';

import node from '@gossi/config-eslint/node';

const gitignorePath = fileURLToPath(new URL('.gitignore', import.meta.url));

export default defineConfig([
  includeIgnoreFile(gitignorePath, 'Imported .gitignore patterns'),
  {
    // wrangler's generated dev bundles and deploy output are not source
    ignores: ['.wrangler/**', 'dist/**']
  },
  ...node(import.meta.dirname)
]);
