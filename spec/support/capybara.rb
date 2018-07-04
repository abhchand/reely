require "capybara/rails"
require "capybara/rspec"
require "capybara-webkit"
require "capybara-screenshot/rspec"

Capybara.configure do |config|
  config.ignore_hidden_elements = true
  config.javascript_driver = :webkit
end

Capybara::Screenshot.autosave_on_failure = false

Capybara::Webkit.configure do |config| # rubocop:disable Style/SymbolProc
  config.block_unknown_urls
end
