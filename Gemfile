source "https://rubygems.org"

gem "rails", "~> 5.2", ">= 5.2.2"
ruby "2.5.1"

#
# Front End
#
gem "i18n-js", ">= 3.0.0.rc11"
gem "inline_svg", "~> 0.6.1"
gem "jbuilder", "~> 2.7"
gem "react-rails", "~> 2.4", ">= 2.4.7"
gem "sass-rails", "~> 5.0", ">= 5.0.7"
gem "sdoc", "~> 0.4.0", group: :doc
gem "uglifier", ">= 1.3.0"
gem "webpacker", "~> 3.5", ">= 3.5.5"

#
# Back End
#
gem "bcrypt", "~> 3.1", ">= 3.1.10"
gem "dotenv-rails", "~> 2.6"
gem "exiftool", "~> 1.0"
gem "interactor", "~> 3.0"
gem "marcel", "~> 0.3.3"
gem "mini_magick", "~> 4.9", ">= 4.9.3"
gem "pg", "~> 0.18.4"
gem "puma", "~> 3.4"
gem "rolify", "~> 5.2"
gem "sidekiq", "~> 5.2", ">= 5.2.5"

group :production do
  gem "foreman", "~> 0.85.0"
end

group :development, :test do
  gem "factory_bot_rails", "~> 4.5"
  gem "pry-rails"
  gem "rspec-rails", "~> 3.8"
  gem "rubocop", "~> 0.57.2"
end

group :development do
  gem "better_errors"
  gem "capistrano", "~> 3.5"
  gem "capistrano-bundler", "~> 1.1", ">= 1.1.4"
  gem "capistrano-rails", "~> 1.1", ">= 1.1.7"
  gem "capistrano-rvm", "~> 0.1.2"
  gem "highline", "~> 2.0"
  gem "rubocop-git", "~> 0.1.3"
  gem "spring"
  gem "web-console", "~> 2.0"
end

group :test do
  gem "capybara", "~> 3.9"
  gem "capybara-screenshot"
  gem "database_cleaner", "~> 1.5", ">= 1.5.1"
  gem "mock_redis", "~> 0.19.0"
  gem "rails-controller-testing"
  gem "rake"
  gem "selenium-webdriver", "~> 3.14"
  gem "shoulda-matchers", "~> 4.0", ">= 4.0.1", require: false
end
