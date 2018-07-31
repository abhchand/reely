require "rails_helper"

RSpec.describe DateRangeLabelService, type: :service do
  let(:user) { create(:user) }

  it "generates the date range label" do
    date = [
      ["Mar 16, 2009", "Apr 20, 2016"],
      ["Mar 16, 2009", "Apr 20, 2009"],   # Same year
      ["Mar 16, 2009", "Mar 20, 2009"],   # Same month
      ["Mar 16, 2009", "Mar 16, 2009"],   # Same day
    ]

    expected = [
      "16 Mar 2009 - 20 Apr 2016",
      "16 Mar - 20 Apr 2009",
      "16 - 20 Mar 2009",
      "16 Mar 2009"
    ]

    date.each_with_index do |(start_date_str, end_date_str), i|
      photos = generate_photos_with_date_range(start_date_str, end_date_str)
      label = DateRangeLabelService.call(photos)

      expect(label).to eq(expected[i])
    end
  end

  context "photos array is empty" do
    it "returns nil" do
      label = DateRangeLabelService.call([])
      expect(label).to be_nil
    end
  end

  def generate_photos_with_date_range(start_date_str, end_date_str)
    start_date = Time.zone.parse(start_date_str)
    end_date = Time.zone.parse(end_date_str)

    [
      create(:photo, owner: user, taken_at: start_date),
      create(:photo, owner: user, taken_at: end_date)
    ]
  end
end
