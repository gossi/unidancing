import config from '@gossi/config-stylelint';

export default {
  ...config,
  overrides: [
    ...(config.overrides ?? []),
    {
      // co-located stylesheets are transformed by ember-scoped-css:
      // flag selectors that cannot be scoped (they would silently leak global)
      files: ['app/domain/**/*.css'],
      extends: ['stylelint-ember-scoped-css/config']
    }
  ]
};
