require "capybara/rails"
require "capybara/rspec"
require "selenium/webdriver"
require "capybara-screenshot/rspec"

Capybara.configure do |config|
  config.ignore_hidden_elements = true
  config.javascript_driver = :selenium_chrome_headless
end

Capybara::Screenshot.autosave_on_failure = false
