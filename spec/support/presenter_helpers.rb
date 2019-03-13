RSpec.configure do |config|
  config.include Rails.application.routes.url_helpers, type: :presenter
end
