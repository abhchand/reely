require_relative 'general_helpers'

RSpec.configure do |config|
  config.before(:suite) { GeneralHelpers.clear_storage! }
end
