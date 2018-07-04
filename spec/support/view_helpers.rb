Dir[Rails.root.join("spec/support/view_helpers/*.rb")].each do |file|
  require file
end

RSpec.configure do |config|
  config.include ViewHelpers, type: :view
end
