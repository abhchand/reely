Dir[Rails.root.join("spec/support/feature_helpers/*.rb")].each do |file|
  require file
end

RSpec.configure do |config|
  config.include FeatureHelpers, type: :feature
end
