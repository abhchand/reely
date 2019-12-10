require File.expand_path("boot", __dir__)

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Reely
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified
    # here. Application configuration should go into files in
    # config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record
    # auto-convert to this zone. Run "rake -D time" for a list of tasks for
    # finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from
    # config/locales/*.rb,yml are auto loaded.
    # rubocop:disable Metrics/LineLength
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    # rubocop:enable Metrics/LineLength

    # Disable the built-in asset pipeline
    config.assets.enabled = false

    # Each controller/view pair should only include it's own helpers
    config.include_all_helpers = false

    config.generators do |g|
      # Don't generate certain files during `rails generate` calls
      g.javascripts = false
      g.stylesheets = false
      g.helper = false
      g.factory_bot = false

      g.test_framework :rspec
    end

    # Custom Configs
    config.x.email_format = /\A.*@.+\..+\z/
    config.x.allowed_photo_types = %w[image/bmp image/jpeg image/png image/tiff]
    config.x.default_import_dir = Rails.root.join("import")
    config.x.default_url_options =
      case
      when Rails.env.test?
        { host: "localhost", port: "3000" }
      when Rails.env.development?
        {
          host: ENV.fetch("APP_HOST", "localhost"),
          port: ENV.fetch("APP_PORT", "3000")
        }
      when Rails.env.production?
        { host: ENV.fetch("APP_HOST") }
      end

    Rails.application.routes.default_url_options.merge!(
      config.x.default_url_options
    )
  end
end
