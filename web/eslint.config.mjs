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
    // Test suite runs on vitest (see tests/ + vite.config.mts `test`). The
    // qunit recommended set that @gossi/config-eslint/ember spreads onto
    // `tests/**/*-test.*` only misfires on vitest files (e.g. qunit/require-expect
    // flagging `expect()` from 'vitest'). Deactivated explicitly — the ember
    // preset imports the plugin statically, so it cannot go away app-side yet,
    // but 'off' is also harmless once eslint-plugin-qunit is fully pruned.
    name: 'app/no-qunit',
    rules: {
      'qunit/assert-args': 'off',
      'qunit/literal-compare-order': 'off',
      'qunit/no-arrow-tests': 'off',
      'qunit/no-assert-equal': 'off',
      'qunit/no-assert-equal-boolean': 'off',
      'qunit/no-assert-logical-expression': 'off',
      'qunit/no-assert-ok': 'off',
      'qunit/no-async-in-loops': 'off',
      'qunit/no-async-module-callbacks': 'off',
      'qunit/no-async-test': 'off',
      'qunit/no-commented-tests': 'off',
      'qunit/no-compare-relation-boolean': 'off',
      'qunit/no-conditional-assertions': 'off',
      'qunit/no-early-return': 'off',
      'qunit/no-global-assertions': 'off',
      'qunit/no-global-expect': 'off',
      'qunit/no-global-module-test': 'off',
      'qunit/no-global-stop-start': 'off',
      'qunit/no-hooks-from-ancestor-modules': 'off',
      'qunit/no-identical-names': 'off',
      'qunit/no-init': 'off',
      'qunit/no-jsdump': 'off',
      'qunit/no-loose-assertions': 'off',
      'qunit/no-negated-ok': 'off',
      'qunit/no-nested-tests': 'off',
      'qunit/no-ok-equality': 'off',
      'qunit/no-only': 'off',
      'qunit/no-qunit-push': 'off',
      'qunit/no-qunit-start-in-tests': 'off',
      'qunit/no-qunit-stop': 'off',
      'qunit/no-reassign-log-callbacks': 'off',
      'qunit/no-reset': 'off',
      'qunit/no-setup-teardown': 'off',
      'qunit/no-skip': 'off',
      'qunit/no-test-expect-argument': 'off',
      'qunit/no-throws-string': 'off',
      'qunit/require-expect': 'off',
      'qunit/require-object-in-propequal': 'off',
      'qunit/resolve-async': 'off'
    }
  },
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
