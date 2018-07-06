require "rails_helper"

RSpec.describe "layouts/with_responsive_navigation.html.erb", type: :view do
  # This layout is difficult to test in a view spec because it's rendered
  # through the parent `application` layout which the view specs don't like
  # Any relevant specs are tested in feature specs
  # (see `spec/features/desktop_navigation_spec.rb`)
  # This file is just an informative placeholder
end
