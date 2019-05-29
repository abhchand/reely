module.exports = {
  test: /\.jsx?$/,
  exclude: /node_modules/,
  use: [{
    loader: "babel-loader",
    options: {
      cacheDirectory: true,
      // Use .babelrc - not webpack config JS - to define all options
      babelrc: true
    }
  }]
}
