require "rails_helper"
require_relative "../shared/photo_grid_spec"

RSpec.describe "photos/index.html.erb", type: :view do
  let(:user) { create(:user) }
  let(:photos) { create_list(:photo, 2) }

  before do
    stub_template "shared/_photo_count.html.erb" => "_stubbed_photo_count"

    assign(:photos, photos)
    assign(:photo_count, photos.count)

    @t_prefix = "photos.index"
  end

  it "renders the photo count" do
    render
    expect(rendered).to have_content("_stubbed_photo_count")
  end

  describe "photo grid" do
    it_behaves_like "photo grid"
  end

  context "no photos exist" do
    before do
      assign(:photos, [])
      assign(:photo_count, 0)
    end

    it "displays the empty state" do
      render

      expect(page.find(".photos-index__emtpy-state")).
        to have_content(t("#{@t_prefix}.empty"))

      expect(rendered).to_not have_content("_stubbed_photo_count")
      expect(rendered).
        to_not have_content(".photos-index__photo-grid-container")
    end
  end
end
