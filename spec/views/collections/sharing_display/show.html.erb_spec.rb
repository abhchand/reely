require "rails_helper"

RSpec.describe "collections/sharing_display/show.html.erb", type: :view do
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
    stub_template("layouts/_flash.html.erb" => "_stubbed_flash")
    stub_template("shared/_photo_count.html.erb" => "_stubbed_photo_count")

    @t_prefix = "collections.sharing_display.show"
  end

  it "renders the flash" do
    render
    expect(rendered).to have_content("_stubbed_flash")
  end

  it "renders a static non-editable heading" do
    render

    expect(page.find("h1.page-heading")).to have_content(@collection.name)
  end

  it "renders the photo count and date range label" do
    render

    expect(page).to have_content("_stubbed_photo_count")
  end

  it "renders the file download component" do
    render

    component = "collections-sharing-display-download-files"
    props = { collection: @collection.as_json(include: %(share_id)) }

    expect(page).to have_react_component(component).including_props(props)
  end

  it "renders the photo manager" do
    render

    # rubocop:disable Metrics/LineLength
    props = {
      photos: PhotoPresenter.wrap(@photos, view: view_context).map(&:photo_manager_props),
      permissions: {
        allowAddingToCollection: false,
        allowDeletingCollection: false,
        allowRemovingFromCollection: false,
        allowSharingCollection: false,
        isEditable: false
      }
    }
    # rubocop:enable Metrics/LineLength

    expect(page).to have_react_component("photo-manager").including_props(props)
  end
end
