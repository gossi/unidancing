'use strict';

const EmberApp = require('ember-cli/lib/broccoli/ember-app');
const packageJson = require('./package');
// const { browsers } = require('@gossi/config-targets');
const { importSingleTs } = require('import-single-ts');
const path = require('node:path');

async function findUrls() {
  const { client } = await importSingleTs(
    path.resolve(__dirname, './tina/__generated__/client.ts')
  );

  // arts
  const artsResponse = await client.queries.artConnection();
  const arts = artsResponse.data.artConnection.edges.map((art) => {
    return `/kuenste/${art.node._sys.filename}`;
  });

  // courses
  const coursesResponse = await client.queries.courseConnection();
  const courses = coursesResponse.data.courseConnection.edges.map((course) => {
    return `/courses/${course.node._sys.filename}`;
  });

  // exercises
  const exercisesResponse = await client.queries.exerciseConnection();
  const exercises = exercisesResponse.data.exerciseConnection.edges.map((exercise) => {
    return `/uebungen/${exercise.node._sys.filename}`;
  });

  // moves
  const movesResponse = await client.queries.moveConnection();
  const moves = movesResponse.data.moveConnection.edges.map((move) => {
    return `/moves/${move.node._sys.filename}`;
  });

  // skills
  const skillsResponse = await client.queries.skillConnection();
  const skills = skillsResponse.data.skillConnection.edges.map((skill) => {
    return `/fertigkeiten/${skill.node._sys.filename}`;
  });

  return [
    '/',
    '/kuenste',
    ...arts,
    '/courses',
    ...courses,
    '/fertigkeiten',
    ...skills,
    '/uebungen',
    ...exercises,
    '/moves',
    ...moves,
    '/choreography',
    '/choreography/not-todo-list',
    '/training',
    '/training/control',
    '/training/diagnostics',
    '/training/diagnostics/time-tracking',
    '/training/diagnostics/body-language',
    '/training/tools',
    '/training/games'
  ];
}

function isProduction() {
  return EmberApp.env() === 'production';
}

module.exports = function (defaults) {
  let app = new EmberApp(defaults, {
    // Add options here
    cssModules: {
      includeExtensionInModulePath: true
    },

    autoImport: {
      watchDependencies: Object.keys(packageJson.dependencies)
    },

    'ember-cli-babel': {
      enableTypeScriptTransform: true
    },

    finterprint: {
      exlude: ['media/']
    },

    prember: {
      urls: findUrls
    }
  });

  const { Webpack } = require('@embroider/webpack');

  const compiledApp = require('@embroider/compat').compatBuild(app, Webpack, {
    staticAddonTestSupportTrees: true,
    staticAddonTrees: true,
    staticHelpers: true,
    staticModifiers: true,
    staticComponents: true,
    // staticEmberSource: true,
    // see: https://github.com/ember-fastboot/ember-cli-fastboot/issues/925#issuecomment-1859135364
    staticEmberSource: false,
    splitAtRoutes: ['courses', 'skills', 'exercises', 'moves', 'choreography', 'training'],
    packagerOptions: {
      webpackConfig: {
        // devtool: process.env.CI ? 'source-map' : 'eval',
        devtool: 'source-map',
        module: {
          rules: [
            {
              // exclude: /node_modules/,
              // test: /\.css$/i,
              test: /(node_modules\/\.embroider\/rewritten-app\/)(.*\.css)$/i,
              use: [
                {
                  loader: 'postcss-loader',
                  options: {
                    // sourceMap: !isProduction()
                    postcssOptions: {
                      config: './postcss.config.js'
                    }
                  }
                }
              ]
            },
            {
              test: /.wav$/,
              type: 'asset/resource',
              generator: {
                filename: 'sounds/[hash][ext][query]'
              }
            }
          ]
        }
      },
      cssLoaderOptions: {
        modules: {
          localIdentName: isProduction() ? '[sha512:hash:base64:5]' : '[path][name]__[local]',
          mode: (resourcePath) => {
            const hostAppLocation = 'node_modules/.embroider/rewritten-app';

            return resourcePath.includes(hostAppLocation) ? 'local' : 'global';
          }
        }
        // sourceMap: !isProduction()
      },
      publicAssetURL: '/'
    }
  });

  // return compiledApp;
  return require('prember').prerender(app, compiledApp);
};
