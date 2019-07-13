require "rails_helper"
require Rails.root.join("spec/support/shared_examples/views/photo_grid")

RSpec.describe "shared_collections/show.html.erb", type: :view do
  let(:user) { create(:user) }

  before do
    @collection = create_collection_with_photos(photo_count: 2)
    @photos = @collection.photos
    @photo_count = 2
    @date_range_label = "date range label"

    assign(:collection, @collection)
    assign(:photos, @photos)
    assign(:photo_count, @photo_count)
    assign(:date_range_label, @date_range_label)

    stub_view_context
    stub_template("shared/_photo_count.html.erb" => "_stubbed_photo_count")

    @t_prefix = "shared_collections.show"
  end

  it "renders a static non-editable heading" do
    render

    expect(page.find("h1.page-heading")).to have_content(@collection.name)
  end

  it "renders the photo count and date range label" do
    render

    expect(page).to have_content("_stubbed_photo_count")
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

      expect(page.find(".shared-collections-show__emtpy-state")).
        to have_content(t("#{@t_prefix}.empty"))

      expect(rendered).to have_content("_stubbed_photo_count")
      expect(rendered).
        to_not have_content(".shared-collections-show__photo-grid-container")
    end
  end
end
