'use strict';

const EmberApp = require('ember-cli/lib/broccoli/ember-app');
// eslint-disable-next-line n/no-missing-require
const { compatBuild } = require('@embroider/compat');

module.exports = async function (defaults) {
  const { buildOnce } = await import('@embroider/vite');

  const app = new EmberApp(defaults, {
    '@embroider/macros': {
      setConfig: {
        'ember-qunit': {
          theme: 'ember'
        }
      }
    },

    'ember-cli-babel': {
      enableTypeScriptTransform: true
    }
  });

  return compatBuild(app, buildOnce, {
    splitAtRoutes: ['courses', 'skills', 'exercises', 'moves', 'choreography', 'training']
  });
};
