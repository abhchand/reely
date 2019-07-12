const { environment } = require('@rails/webpacker');

const rails_erb = require('./loaders/rails-erb');
environment.loaders.append('erb', rails_erb);

const babel = require('./loaders/babel');
environment.loaders.append('babel', babel);

const provide = require('./plugins/provide');
environment.plugins.prepend('Provide', provide);

module.exports = environment;
