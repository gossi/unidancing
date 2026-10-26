import config from '@gossi/config-template-lint';

export default {
  ...config,
  plugins: [...(config.plugins ?? []), 'ember-scoped-css/src/template-lint/plugin'],
  rules: {
    ...config.rules,
    'scoped-class-helper': 'error',
    'no-passed-in-event-handlers': {
      ignore: {
        Form: ['submit', 'reset'],
        'this.Form': ['submit', 'reset'],
        RoutineTesterForm: ['submit', 'reset'],
        TrainingTesterForm: ['submit', 'reset']
      }
    },
    'require-valid-named-block-naming-format': 'kebab-case'
  }
};
