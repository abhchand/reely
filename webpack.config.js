/* eslint-disable prefer-named-capture-group */
/* eslint-disable no-process-env */

const devMode = process.env.NODE_ENV === 'development';
const testMode = process.env.NODE_ENV === 'test';
// eslint-disable-next-line
const prodMode = process.env.NODE_ENV === 'production';

const path = require('path');

const ASSETS_DIR = path.resolve(__dirname, 'app/frontend');

const PUBLIC_DIR = path.resolve(__dirname, 'public');
const PACKS_DIR = path.resolve(
  __dirname,
  testMode ? 'public/packs-test' : 'public/packs'
);
const IMAGES_DIR = path.resolve(
  __dirname,
  testMode ? 'public/assets/images-test' : 'public/assets/images'
);

const PUBLIC_PATH = testMode ? '/packs-test/' : '/packs/';

const CaseSensitivePathsPlugin = require('case-sensitive-paths-webpack-plugin');
const CopyPlugin = require('copy-webpack-plugin');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const WebpackAssetsManifest = require('webpack-assets-manifest');
const webpack = require('webpack');

const config = {
  mode: testMode ? 'none' : process.env.NODE_ENV,
  output: {
    filename: '[name]-[fullhash].js',
    chunkFilename: '[name]-[chunkhash].chunk.js',
    path: PACKS_DIR,
    publicPath: PUBLIC_PATH,
    pathinfo: true,
    // https://github.com/webpack/webpack/issues/6693#issuecomment-745688108
    hotUpdateChunkFilename: '[id].[fullhash].hot-update.js',
    hotUpdateMainFilename: '[fullhash].hot-update.json'
  },
  resolve: {
    extensions: [
      '.erb',
      '.jsx',
      '.js',
      '.sass',
      '.scss',
      '.css',
      '.module.sass',
      '.module.scss',
      '.module.css',
      '.png',
      '.svg',
      '.gif',
      '.jpeg',
      '.jpg'
    ],
    modules: [ASSETS_DIR, 'node_modules']
  },
  resolveLoader: {
    modules: ['node_modules']
  },
  devtool: 'cheap-module-source-map',
  devServer: {
    clientLogLevel: 'none',
    compress: true,
    quiet: false,
    disableHostCheck: true,
    host: 'localhost',
    port: 3035,
    https: false,
    hot: true,

    /*
     * Note: `publicPath` takes precedence if defined
     * so don't define it and just serve all content
     * as static from the `public/` directory
     */
    contentBase: PUBLIC_DIR,
    inline: true,
    useLocalIp: false,
    public: 'localhost:3035',
    historyApiFallback: {
      disableDotRule: true
    },
    headers: {
      'Access-Control-Allow-Origin': '*'
    },
    overlay: true,
    stats: {
      errorDetails: true
    },
    watchOptions: {
      ignored: '/node_modules/'
    },

    /*
     * Webpack-dev-server serves assets from memory. Since
     * the assets/images/* files are statically copied (via the
     * `CopyPlugin` below) and not built as a webpack "pack"
     * (using a defined 'entry point') they are not served
     * from webpack dev server's memory. To get around this
     * we write these files to disk and the dev server will
     * fallback to looking for them on the disk since we
     * statically serve everything under the public directory
     */
    writeToDisk: (filePath) => {
      return /assets\/images\//u.test(filePath);
    }
  },
  entry: {
    admin: {
      import: [
        `${ASSETS_DIR}/javascript/packs/admin.js`,
        `${ASSETS_DIR}/stylesheets/packs/admin.scss`
      ],
      dependOn: 'common'
    },
    auth: {
      import: [
        `${ASSETS_DIR}/javascript/packs/auth.js`,
        `${ASSETS_DIR}/stylesheets/packs/auth.scss`
      ],
      dependOn: 'common'
    },
    common: [
      `${ASSETS_DIR}/javascript/packs/common.js`,
      `${ASSETS_DIR}/stylesheets/packs/common.scss`
    ],
    collections: {
      import: [
        `${ASSETS_DIR}/javascript/packs/collections.js`,
        `${ASSETS_DIR}/stylesheets/packs/collections.scss`
      ],
      dependOn: 'common'
    },
    i18n: [`${ASSETS_DIR}/javascript/packs/i18n.js`],
    'users-index': {
      import: [
        `${ASSETS_DIR}/javascript/packs/users-index.js`,
        `${ASSETS_DIR}/stylesheets/packs/users-index.scss`
      ],
      dependOn: 'common'
    }
  },
  module: {
    strictExportPresence: true,
    rules: [
      {
        test: /\.(css)$/iu,
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
            options: {}
          },
          {
            loader: 'css-loader',
            options: {
              sourceMap: true,
              importLoaders: 2,
              modules: false
            }
          }
        ]
      },
      {
        test: /\.(scss|sass)$/iu,
        use: [
          {
            loader: MiniCssExtractPlugin.loader,
            options: {}
          },
          {
            loader: 'css-loader',
            options: {
              sourceMap: true,
              importLoaders: 2,
              modules: false
            }
          },
          {
            loader: 'sass-loader',
            options: {
              sourceMap: true
            }
          }
        ]
      },
      {
        test: /\.(jpg|jpeg|png|gif|tiff|ico|svg|eot|otf|ttf|woff|woff2)$/iu,
        use: [
          {
            loader: 'file-loader',
            options: {
              name: '[path][name]-[fullhash].[ext]'
            }
          }
        ]
      },
      {
        test: /\.erb$/u,
        enforce: 'pre',
        exclude: /node_modules/u,
        use: [
          {
            loader: 'rails-erb-loader',
            options: {
              runner: 'bin/rails runner'
            }
          }
        ]
      },
      {
        test: /\.(js|jsx)?(\.erb)?$/u,
        exclude: /node_modules/u,
        use: [
          {
            loader: 'babel-loader',
            options: {
              cacheDirectory: true,
              babelrc: true
            }
          }
        ]
      }
    ]
  },
  plugins: [
    new webpack.ProvidePlugin({
      $: 'jquery',
      JQuery: 'jquery',
      jquery: 'jquery'
    }),
    new webpack.EnvironmentPlugin(['NODE_ENV']),
    new CaseSensitivePathsPlugin(),
    new MiniCssExtractPlugin({
      filename: testMode || devMode ? '[name].css' : '[name]-[contenthash].css',
      chunkFilename:
        testMode || devMode ? '[id].chunk.css' : '[id]-[contenthash].chunk.css'
    }),
    new CopyPlugin({
      patterns: [
        {
          from: '**/*',
          context: `${ASSETS_DIR}/images`,
          to: IMAGES_DIR
        }
      ]
    }),
    new WebpackAssetsManifest({
      integrity: false,
      entrypoints: false,
      writeToDisk: true,
      publicPath: PUBLIC_PATH
    })
  ]
};

module.exports = config;
