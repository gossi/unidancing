# @unidancing/app

The UniDancing web app — an Ember application built with **Vite** (Embroider v4,
compatless/strict mode) and prerendered at build time via
[vite-ember-ssr](https://github.com/evoactivity/vite-ember-ssr) (SSG only, no
server runtime — the static `dist/` is deployed to Cloudflare Pages).

Content comes from [Tina CMS](https://tinacms.org/): the content graph lives in
`content/` (repo root), the admin in `tina/`, and page data is queried through
the generated client in `tina/__generated__/`.

## Prerequisites

* [Git](https://git.com/)
* [Node.js](https://nodejs.org/) >= 22 (see `.node-version` at the repo root)
* [pnpm](https://pnpm.io/)
* [Playwright chromium](https://playwright.dev/) (for the test suite — `pnpm exec playwright install chromium`)

## Running / Development

From the repo root (`pnpm dev` in this workspace is also wired through turbo):

```sh
pnpm dev            # tinacms dev server + Vite dev server
```

* Visit your app at [http://localhost:4200](http://localhost:4200).
* Run the tests with `pnpm test:watch` (vitest UI) — tests live in `tests/`,
  served by vitest browser mode (chromium via playwright).
* Tina admin at [http://localhost:4001/admin](http://localhost:4001/admin).

`pnpm start` runs only the Vite dev server. Content queries then still require
the Tina content server — run `pnpm start:tina` separately if you start Vite on
its own.

### Configuration

There is no `config/environment.js` anymore; the app config is a regular module
in `app/config/environment.ts`. Runtime-configurable values come from `.env`
files via Vite (see `envPrefix` in `vite.config.ts`; `YOUTUBE_API_KEY` is
exposed from `.env`).

### Building / Prerendering

```sh
pnpm build          # tinacms build + vite build (incl. SSG prerendering)
```

`vite build` in production mode additionally:

1. enumerates the content routes at build time by querying the Tina GraphQL
   endpoint baked into `tina/__generated__/client.ts` (see `findRoutes()` in
   `vite.config.ts`);
2. renders every route with `vite-ember-ssr` (happy-dom, no FastBoot) and writes
   `<route>/index.html` into `dist/`;
3. embeds the fetched content as a JSON data island
   (`#unidancing-data`, see `app/services/app-data-cache.ts`) so the browser
   boots from the prerendered data without re-querying the content API.

Prerendering runs against whatever endpoint `tinacms build` generated — the
local dev server or Tina Cloud (with `TINA_CLIENT_ID`/`TINA_TOKEN`, as passed
through by turbo). `pnpm build:tina` must run before `vite build`.

### Running Tests

```sh
pnpm test           # vitest run (browser mode, chromium via playwright)
```

Tests run in vitest browser mode (see `vite.config.ts` → `test`). Run
`pnpm test:prebuild` first to generate a local Tina client when testing offline.

### Linting

```sh
pnpm lint           # eslint, stylelint, glint
pnpm lint:fix
```

### Code Generators

The classic `ember generate` generators no longer apply — files are plain ES
modules; copy an existing route/component/service as a template. `ember-cli`
remains installed only for the test runner.

## Architecture notes

* **Compatless Embroider** — no `ember-cli-build.js`; the app boots through
  `app/entry.ts` and uses `ember-strict-application-resolver`
  (`app/app.ts`) with `import.meta.glob` module registration. Services that are
  looked up by string (`@service declare …`) must be registered in that
  modules map.
* **Code splitting** — `splitAtRoutes` is compat-only. Lazy route bundles are
  declared explicitly in `app/route-splitting.ts` and consumed by
  `@embroider/router` via `window._embroiderRouteBundles_`.
* **Server-render detection** — `isSSR()` from
  `app/domain/supporting/utils` is backed by a flag that only `app/app-ssr.ts`
  (the SSG entry) sets.
* **Theming** — design tokens from `@unidancing/theme` are processed by
  `@theemo/vite` (see `vite.config.ts`); no custom webpack plugin anymore.

## Deploying

Cloudflare Pages, static output from `web/dist` (same layout as before the
Vite migration: `<route>/index.html` per prerendered page, SPA fallback for
app routes like `/training/*`).

## Further Reading / Useful Links

* [ember.js](https://emberjs.com/)
* [Vite build tooling guide](https://guides.emberjs.com/release/build-tools/vite/)
* [Embroider](https://github.com/embroider-build/embroider)
* [vite-ember-ssr](https://github.com/evoactivity/vite-ember-ssr)
* [TinaCMS](https://tinacms.org/)
* Development Browser Extensions
  * [ember inspector for chrome](https://chrome.google.com/webstore/detail/ember-inspector/bmdblncegkenkacieihfhpjfppoconhi)
  * [ember inspector for firefox](https://addons.mozilla.org/en-US/firefox/addon/ember-inspector/)
