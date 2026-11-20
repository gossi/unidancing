import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { includeIgnoreFile } from '@eslint/compat';
import { defineConfig } from 'eslint/config';
import boundaries from 'eslint-plugin-boundaries';
import { plugin as emberPlugin } from 'eslint-plugin-ember/recommended';

import ember from '@gossi/config-eslint/ember';

const gitignorePath = fileURLToPath(new URL('.gitignore', import.meta.url));

// core domains, mirroring the `#<domain>` import map in package.json
const DOMAINS = [
  'arts',
  'assistants',
  'choreography',
  'courses',
  'exercises',
  'games',
  'home',
  'moves',
  'skills',
  'training'
];

export default defineConfig([
  includeIgnoreFile(gitignorePath, 'Imported .gitignore patterns'),
  {
    ignores: ['public/admin', 'types', 'tina']
  },
  ...ember(import.meta.dirname),
  {
    // Test suite runs on vitest (see tests/ + vite.config.ts `test`). The
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
    // rules must be declared alongside the plugin that provides them
    plugins: { ember: emberPlugin },
    rules: {
      'unicorn/consistent-function-scoping': 'off',
      'unicorn/consistent-class-member-order': 'off',
      // Both rules rewrite `if (obj[key])` existence checks to
      // `Object.hasOwn(obj, key)` — which throws on Glimmer's NamedArgsProxy
      // (no real property descriptors; see getParam in dance-oh-mat/dance-mix)
      // and changes truthiness semantics (null/0-valued entries slip through).
      'prefer-object-has-own': 'off',
      'unicorn/no-computed-property-existence-check': 'off',
      // the tester forms are app-level wrappers around `<Form>` and forward the
      // native form events as component arguments, same as `Form` itself; the
      // shared preset ignores `Form`/`Pagination` — this extends that list
      // (rule options are replaced, not merged, so re-declare the shared ones).
      // Ported from the old `.template-lintrc` `no-passed-in-event-handlers` config.
      'ember/template-no-passed-in-event-handlers': [
        'error',
        {
          ignore: {
            Form: ['submit', 'reset'],
            Pagination: ['change'],
            RoutineTesterForm: ['submit', 'reset'],
            TrainingTesterForm: ['submit', 'reset']
          }
        }
      ]
    }
  },
  {
    // Architectural boundaries (https://www.jsboundaries.dev/) — recreates
    // the module discipline of the sportipedia app layout: every core domain
    // and support module is an element whose `index.ts` barrel is its public
    // API. App-assembly wiring is exported from that barrel as a `*Manifest`
    // object.
    name: 'app/boundaries',
    files: ['src/**/*.{ts,gts}', 'tests/**/*.{ts,gts}'],
    plugins: { boundaries },
    settings: {
      'boundaries/root-path': path.resolve(import.meta.dirname),
      // only the classified trees are checked; config files at the root are
      // left to plain ESLint
      'boundaries/include': ['src/**', 'tests/**'],
      // virtual modules contributed by build plugins (unplugin-icons icons,
      // ember-intl translations) behave as packages: they exist only at
      // build time, so no local resolution can ever classify them
      'boundaries/flag-as-external': {
        customSourcePatterns: ['~icons/**', 'virtual:**']
      },
      'boundaries/elements': [
        // most specific first: each support module is its own element
        { type: 'support', pattern: 'src/support/*', capture: ['area'] },
        { type: 'domain', pattern: `src/{${DOMAINS.join(',')}}` },
        { type: 'shell', pattern: 'src/ui' },
        { type: 'service', pattern: 'src/services' },
        // fallback for the app assembly: app.ts, app-ssr.ts, entry.ts, router.ts
        { type: 'app', pattern: 'src' },
        { type: 'test', pattern: 'tests' }
      ],
      // resolve extensionless TS imports, the `#alias` package imports and the
      // .gts specifiers
      'import/resolver': {
        typescript: {
          alwaysTryTypes: true,
          extensions: ['.ts', '.gts', '.js', '.gjs']
        },
        node: {
          extensions: ['.ts', '.gts', '.js', '.gjs']
        }
      }
    },
    rules: {
      'boundaries/dependencies': [
        'error',
        {
          // anything not explicitly allowed below is a boundary violation
          default: 'disallow',
          policies: [
            // third-party packages and node builtins: this is a single app
            // package (one package.json), so externals are not partitioned
            {
              allow: { to: { module: { origin: ['external', 'core'] } } }
            },
            // files may always depend on other files of their own element
            {
              allow: { dependency: { relationship: { to: 'internal' } } }
            },
            // support modules, domains, the shell and app services consume
            // support modules through their barrel (index.ts) only
            {
              from: { element: { type: ['support', 'domain', 'shell', 'service'] } },
              allow: { to: { element: { type: 'support', fileInternalPath: 'index.ts' } } }
            },
            // core domains and the shell consume other domains through their
            // barrel (index.ts) only, never reaching into internals
            {
              from: { element: { type: ['domain', 'shell'] } },
              allow: { to: { element: { type: 'domain', fileInternalPath: 'index.ts' } } }
            },
            // the app assembly (app.ts, router.ts, …) wires everything
            {
              from: { element: { type: 'app' } },
              allow: {
                to: { element: { type: ['domain', 'support', 'shell', 'service'] } }
              }
            },
            // tests see app internals (barrels and deep), never the assembly
            {
              from: { element: { type: 'test' } },
              allow: {
                to: { element: { type: ['domain', 'support', 'shell', 'service'] } }
              }
            },
            // cross-element imports must use the "#alias" public API spelling
            // (package.json "imports"). Relative specifiers are only allowed
            // within one's own element. The negated extglob flags any other
            // local source; the origin-guard keeps third-party and virtual
            // packages out of scope. Order matters: this disallow comes after
            // the allow-policies, and the internal re-allow below re-claims
            // intra-element relative imports.
            {
              from: { element: { type: ['domain', 'support', 'shell', 'service'] } },
              disallow: {
                to: { module: { origin: 'local' } },
                dependency: { source: ['!@(#*|#*/**)'] }
              },
              message:
                'Cross-element imports must use the #alias public API (see package.json "imports") — target: {{to.element.path}}'
            },
            {
              // re-allow intra-element relative imports (must follow the disallow)
              from: { element: { type: ['domain', 'support', 'shell', 'service'] } },
              allow: { dependency: { relationship: { to: 'internal' } } }
            }
          ]
        }
      ],
      // unresolvable local imports must not silently escape boundary checks
      'boundaries/no-unknown-dependencies': 'error',
      // new source directories need an explicit element classification
      'boundaries/no-unknown-files': 'error'
    }
  }
]);
