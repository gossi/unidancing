module.exports = function (/* environment */) {
  return {
    // Path where translations are stored, relative to the project root.
    inputPath: 'translations',

    // Prevents the translations from being bundled with the application code.
    // See: https://ember-intl.github.io/ember-intl/docs/guide/asynchronously-loading-translations
    publicOnly: false,

    // Add the subdirectories of the translations as a namespace for all keys.
    wrapTranslationsWithNamespace: true
  };
};
