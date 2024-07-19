'use strict';

const EmberApp = require('ember-cli/lib/broccoli/ember-app');
// eslint-disable-next-line n/no-missing-require
const { HokuleaAssetLoaderWebpackPlugin } = require('@hokulea/ember/lib');
// eslint-disable-next-line n/no-missing-require
const theemoPlugin = require('ember-theemo/lib/webpack');
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
    '/training/planning',
    '/training/planning/assistants',
    '/training/planning/games',
    '/training/control',
    '/training/diagnostics',
    '/training/diagnostics/time-tracking',
    '/training/diagnostics/body-language'
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

    // autoImport: {
    //   watchDependencies: Object.keys(packageJson.dependencies)
    // },

    'ember-cli-babel': {
      enableTypeScriptTransform: true
    },

    finterprint: {
      exlude: ['media/']
    },

    prember: {
      urls: findUrls
    },

    babel: {
      plugins: [require.resolve('ember-concurrency/async-arrow-task-transform')]
    },

    theemo: {
      defaultTheme: 'unidancing'
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
        plugins: [theemoPlugin(), new HokuleaAssetLoaderWebpackPlugin()],
        resolve: {
          alias: {
            // // core
            // '@unidancing/arts': path.resolve(__dirname, 'app/domain/core/arts'),
            // '@unidancing/assistants': path.resolve(__dirname, 'app/domain/core/assistants'),
            // '@unidancing/choreography': path.resolve(__dirname, 'app/domain/core/choreography'),
            // '@unidancing/courses': path.resolve(__dirname, 'app/domain/core/courses'),
            // '@unidancing/exercises': path.resolve(__dirname, 'app/domain/core/exercises'),
            // '@unidancing/games': path.resolve(__dirname, 'app/domain/core/games'),
            // '@unidancing/home': path.resolve(__dirname, 'app/domain/core/home'),
            // '@unidancing/moves': path.resolve(__dirname, 'app/domain/core/moves'),
            // '@unidancing/skills': path.resolve(__dirname, 'app/domain/core/skills'),
            // '@unidancing/training': path.resolve(__dirname, 'app/domain/core/training'),

            // // supporting
            // '@unidancing/audio': path.resolve(__dirname, 'app/domain/supporting/audio'),
            // '@unidancing/spotify': path.resolve(__dirname, 'app/domain/supporting/spotify'),
            // '@unidancing/tina': path.resolve(__dirname, 'app/domain/supporting/tina'),
            // '@unidancing/ui': path.resolve(__dirname, 'app/domain/supporting/ui'),
            // '@unidancing/utils': path.resolve(__dirname, 'app/domain/supporting/utils'),

            // libs
            '@/tina': path.resolve(__dirname, 'tina/__generated__')
          }
        },
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
