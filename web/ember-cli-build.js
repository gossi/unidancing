'use strict';

const EmberApp = require('ember-cli/lib/broccoli/ember-app');
const packageJson = require('./package');
const { browsers } = require('@gossi/config-targets');
const { importSingleTs } = require('import-single-ts');
const path = require('node:path');

async function findUrls() {
  const { client } = await importSingleTs(
    path.resolve(__dirname, './tina/__generated__/client.ts')
  );

  // exercises
  const exercisesResponse = await client.queries.exercisesConnection();
  const exercises = exercisesResponse.data.exercisesConnection.edges.map((exercise) => {
    return `/uebungen/${exercise.node._sys.filename}`;
  });

  console.log('exercises', exercises);

  return [
    '/',
    '/courses',
    '/fertigkeiten',
    '/uebungen',
    // ...exercises,
    '/moves',
    '/choreography',
    '/training'
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
    }

    // prember: {
    //   urls: findUrls
    // }
  });

  const { Webpack } = require('@embroider/webpack');

  const compiledApp = require('@embroider/compat').compatBuild(app, Webpack, {
    staticAddonTestSupportTrees: true,
    staticAddonTrees: true,
    staticHelpers: true,
    staticModifiers: true,
    staticComponents: true,
    staticEmberSource: true,
    splitAtRoutes: ['courses', 'skills', 'exercises', 'moves', 'choreography', 'training'],
    packagerOptions: {
      webpackConfig: {
        devtool: process.env.CI ? 'source-map' : 'eval',
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

  return compiledApp;
  // return require('prember').prerender(app, compiledApp);
};
