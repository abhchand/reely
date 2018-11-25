Rails.logger = Logger.new(Rails.root.join("log", "#{Rails.env}.log"))

Rails.logger.datetime_format = "%Y-%m-%d %H:%M:%S"

# The environment-specific production.rb file runs before the initializers,
# so set the logging level explicitly after defining the logger
Rails.logger.level = Logger::INFO if Rails.env.production?
