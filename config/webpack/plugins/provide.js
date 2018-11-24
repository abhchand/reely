const webpack = require('webpack')

module.exports = new webpack.ProvidePlugin({
  // Note: Webpack's `Provide` plugin only replaces jquery dependencies at runtime
  // JQuery still needs to be exposed globally, which is done in `common.js`
  $: 'jquery',
  JQuery: 'jquery',
  jquery: 'jquery'
});
