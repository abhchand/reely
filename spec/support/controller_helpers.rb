Dir[Rails.root.join('spec/support/controller_helpers/*.rb')].each do |file|
  require file
end

RSpec.configure { |config| config.include ControllerHelpers, type: :controller }
