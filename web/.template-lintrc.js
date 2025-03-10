'use strict';

const config = require('@gossi/config-template-lint');

module.exports = {
  ...config,
  rules: {
    ...(config.rules || {}),
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
