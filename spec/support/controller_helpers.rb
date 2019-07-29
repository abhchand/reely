Dir[Rails.root.join("spec/support/controller_helpers/*.rb")].each do |file|
  require file
end

RSpec.configure do |config|
  config.include ControllerHelpers, type: :controller
end
