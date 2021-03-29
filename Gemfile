source "https://rubygems.org"

gem "rails", "6.0.3.6"
ruby "2.5.5"

#
# Front End
#
gem "i18n-js", ">= 3.0.0.rc11"
gem "inline_svg", "~> 1.5", ">= 1.5.2"

#
# Back End
#
gem "audited", "~> 4.9"
gem "bcrypt", "~> 3.1", ">= 3.1.10"
gem "cancancan", "~> 3.0"
gem "devise", "~> 4.7", ">= 4.7.1"
gem "dotenv-rails", "~> 2.7", ">= 2.7.5"
gem "exiftool", "~> 1.0"
gem "fast_jsonapi", "~> 1.6.0", git: "https://github.com/fast-jsonapi/fast_jsonapi"
gem "image_processing", "~> 1.2"
gem "interactor", "~> 3.0"
gem "marcel", "~> 1.0", ">= 1.0.1"
gem "omniauth", "~> 1.9"
gem "omniauth-google-oauth2", "~> 0.8.0"
gem "pg", "~> 0.18.4"
gem "puma", "~> 3.4"
gem "recipient_interceptor", "~> 0.2.0"
gem "rolify", "~> 5.2"
gem "sidekiq", "~> 5.2", ">= 5.2.5"
gem "smtpapi", "~> 0.1.0"
gem "will_paginate", "~> 3.2", ">= 3.2.1"

#
# Vulnerabilities
#

gem "nokogiri", ">= 1.10.4"     # https://nvd.nist.gov/vuln/detail/CVE-2019-5477
gem "rubyzip", ">= 1.3.0"       # https://nvd.nist.gov/vuln/detail/CVE-2019-16892

group :production do
end

group :development, :test do
  gem "factory_bot_rails", "~> 4.5"
  gem "faker", "~> 2.10", ">= 2.10.1"
  gem "pry-rails"
  gem 'rspec-rails', "~> 4.0.0.beta3"
  gem "rubocop", "~> 0.76.0"
end

group :development, :production do
  gem "aws-sdk-s3", "~> 1.48", require: false
  gem "foreman", "~> 0.86.0"
end

group :development do
  gem "better_errors"
  gem "binding_of_caller", "~> 0.8.0"
  gem "capistrano", "~> 3.5"
  gem "capistrano-bundler", "~> 1.1", ">= 1.1.4"
  gem "capistrano-rails", "~> 1.1", ">= 1.1.7"
  gem "capistrano-rvm", "~> 0.1.2"
  gem "highline", "~> 2.0"
  gem "letter_opener", "~> 1.7"
  gem "rubocop-git", "~> 0.1.3"
  gem "spring"
  gem "web-console", "~> 4.0", ">= 4.0.1"
end

group :test do
  gem "capybara", "~> 3.9"
  gem "capybara-screenshot"
  gem "database_cleaner", "~> 1.5", ">= 1.5.1"
  gem "mock_redis", "~> 0.19.0"
  gem "rails-controller-testing", "~> 1.0", ">= 1.0.4"
  gem "rake"
  gem "selenium-webdriver", "~> 3.14"
  gem "shoulda-matchers", "~> 4.0", ">= 4.0.1", require: false
end
