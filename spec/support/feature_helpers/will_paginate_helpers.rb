module FeatureHelpers
  def click_will_paginate_next
    page.find(".pagination .next_page").click
  end

  def click_will_paginate_previous
    page.find(".pagination .previous_page").click
  end
end
