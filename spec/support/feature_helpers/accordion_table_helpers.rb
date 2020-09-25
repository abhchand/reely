module FeatureHelpers
  def accordion_table_row_for(record)
    type = record.class.name.underscore
    page.find(
      ".accordion-table-row[data-type='#{type}'][data-id='#{record.id}']"
    )
  end

  def within_descendants_of(record, &block)
    type = record.class.name.underscore

    # See: developer.mozilla.org/en-US/docs/Web/CSS/Adjacent_sibling_combinator
    scope =
      page.find(
        ".accordion-table-row[data-type='#{type}'][data-id='#{record.id}'] + " \
          '.accordion-table-row-descendants'
      )

    within(scope) { yield }
  end

  def toggle_accordion_row(record)
    accordion_table_row_for(record).find('.accordion-table-row__expand-arrow')
      .click
  end

  def expect_accordion_table_rows_to_be(data, type:)
    actual =
      page.all(".accordion-table-row[data-type='#{type}']").map do |row|
        row['data-id']
      end
    expected = data.map(&:id).map(&:to_s)

    expect(actual).to eq(expected)
  end
end
