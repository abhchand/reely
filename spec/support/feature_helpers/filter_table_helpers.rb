module FeatureHelpers
  def search_filter_table_for(str)
    page.find(".filter-table__search-input").base.send_keys(str)
    # rubocop:disable Style/Semicolon
    wait_for { sleep(0.5); true }
    # rubocop:enable Style/Semicolon
  end

  def expect_filter_table_total_count_to_be(count)
    # Luckily `to_i` turns a string like "6 users" to `6`
    # This isn't great but it works for basic testing!
    actual = page.find(".filter-table__total-count").text.to_i
    expect(actual).to eq(count)
  end

  def expect_filter_table_records_to_be(records)
    actual = page.all(".filter-table__table tbody tr").map { |r| r["data-id"] }

    if records[0].class.name == "UserInvitation"
      expect(actual).to eq(records.map(&:id).map(&:to_s))
    else
      expect(actual).to eq(records.map(&:synthetic_id))
    end
  end

  def click_filter_table_pagination_next
    page.find(".filter-table__pagination-nav-link--next").click
    # rubocop:disable Style/Semicolon
    wait_for { sleep(0.25); true }
    # rubocop:enable Style/Semicolon
  end

  def click_filter_table_pagination_prev
    page.find(".filter-table__pagination-nav-link--prev").click
    # rubocop:disable Style/Semicolon
    wait_for { sleep(0.25); true }
    # rubocop:enable Style/Semicolon
  end
end
