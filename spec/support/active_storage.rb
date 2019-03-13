require_relative "general_helpers"

RSpec.configure do |config|
  config.before(:suite) do
    GeneralHelpers.clear_storage!
  end
end
