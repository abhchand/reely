require "rails_helper"

RSpec.describe "layouts/with_responsive_navigation.html.erb", type: :view do
  # This layout is difficult to test in a view spec because it's rendered
  # through the parent `application` layout which the view specs don't like
  # Any relevant functionality is tested in other specs.
  # This file is just an informative placeholder
end
