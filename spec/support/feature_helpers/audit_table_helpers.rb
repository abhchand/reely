module FeatureHelpers
  def filter_audit_table_by_modifier_for(audit)
    page.find("tbody tr[data-id='#{audit.id}'] .modifier > a").click
  end

  def audit_table_displayed_descriptions
    page.all("tbody tr .description").map(&:text)
  end

  def clear_audit_table_modifier_filter
    page.find(".admin-audits--filter-enabled .clear a").click
  end

  def expect_audit_table_records_to_be(records)
    actual =
      page.all(".admin-audits__audits-table tbody tr").map do |r|
        r["data-id"]
      end

    expect(actual).to eq(records.map(&:id).map(&:to_s))
  end
end
