Dir[Rails.root.join("spec/support/general_helpers/*.rb")].each do |file|
  require file
end

RSpec.configure do |config|
  config.include GeneralHelpers
end
