'use strict';

const EmberApp = require('ember-cli/lib/broccoli/ember-app');
// eslint-disable-next-line n/no-missing-require
const { HokuleaAssetLoaderWebpackPlugin } = require('@hokulea/ember/lib');
// eslint-disable-next-line n/no-missing-require
const theemoPlugin = require('ember-theemo/lib/webpack');
// const { browsers } = require('@gossi/config-targets');
const path = require('node:path');

function isProduction() {
  return EmberApp.env() === 'production';
}

module.exports = function (defaults) {
  let app = new EmberApp(defaults, {
    '@embroider/macros': {
      setConfig: {
        'ember-qunit': {
          theme: 'ember'
        }
      }
    },

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

    fingerprint: {
      exlude: ['media/']
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

  return compiledApp;
};
