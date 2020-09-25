Dir[Rails.root.join('spec/support/general_helpers/*.rb')].each do |file|
  require file
end

RSpec.configure { |config| config.include GeneralHelpers }
