require Rails.root.join("config/smtp")

# rubocop:disable Metrics/BlockLength

Rails.application.configure do
  # Settings specified here will take precedence over those in
  # config/application.rb.

  # The /rails/mailer preview tries to load all previews under the
  # `preview_path` defined below (e.g. `require spec/mailers/preview/...`)
  # The `Rails.root` isn't in the load and therefore it can't find the previews
  # by default. Not sure if this is really the right workaround, but it seems
  # to work on development without any side effects right now.
  $LOAD_PATH.unshift(Rails.root) unless $LOAD_PATH.include?(Rails.root)

  # Automatically re-build JS translations file (`i18n-js` gem)
  config.middleware.use I18n::JS::Middleware

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # ActionMailer
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method =
    ENV["PREVIEW_EMAIL_IN_BROWSER"].present? ? :letter_opener : :smtp
  config.action_mailer.smtp_settings = SMTP_SETTINGS
  config.action_mailer.preview_path = "spec/mailers/previews"
  config.action_mailer.default_options = { from: ENV.fetch("EMAIL_FROM") }
  config.action_mailer.default_url_options = config.x.default_url_options

  Mail.register_interceptor(
    RecipientInterceptor.new(ENV.fetch("EMAIL_INTERCEPT"))
  )

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join("tmp", "caching-dev.txt").exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for
  # options)
  config.active_storage.service =
    ENV.fetch("ACTIVE_STORAGE_SERVICE", :local)&.to_sym

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  # config.file_watcher = ActiveSupport::EventedFileUpdateChecker
end

# rubocop:enable Metrics/BlockLength
