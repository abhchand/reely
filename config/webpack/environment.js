const { environment } = require('@rails/webpacker');

const erb = require('./loaders/erb');
environment.loaders.append('erb', erb);

const provide = require('./plugins/provide');
environment.plugins.prepend('Provide', provide);

module.exports = environment;
