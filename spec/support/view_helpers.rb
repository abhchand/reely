Dir[Rails.root.join('spec/support/view_helpers/*.rb')].each do |file|
  require file
end

RSpec.configure { |config| config.include ViewHelpers, type: :view }
