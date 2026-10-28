// Config for the `loadTranslations()` plugin of `@ember-intl/vite` (see
// `vite.config.ts`). Replaces the former `config/ember-intl.cjs` from the
// ember-cli days, which nothing loads anymore (`ember-intl` v9 is a v2 addon).
export default {
  buildOptions: {
    // Translations live in ./translations, relative to the project root.
    // This is also the default — kept explicit as documentation.
    translationsDir: 'translations',

    // Add the subdirectories of the translations as a namespace for all keys
    // (the old `wrapTranslationsWithNamespace` option).
    namespaceKeysByDir: true
  }
};
