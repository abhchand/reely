const webpack = require('webpack')

module.exports = new webpack.ProvidePlugin({
  // Note: Webpack's `Provide` plugin only replaces jquery dependencies at runtime
  // JQuery still needs to be exposed globally, which is done in the `application.js`
  // pack
  $: 'jquery',
  JQuery: 'jquery',
  jquery: 'jquery'
});
