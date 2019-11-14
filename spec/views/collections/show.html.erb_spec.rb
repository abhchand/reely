require "rails_helper"

RSpec.describe "collections/show.html.erb", type: :view do
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
    stub_template("_delete_modal.html.erb" => "_stubbed_delete_modal")
    stub_template(
      "_editable_name_heading.html.erb" => "_stubbed_editable_name_heading"
    )
    stub_template("shared/_photo_count.html.erb" => "_stubbed_photo_count")

    @t_prefix = "collections.show"
  end

  it "renders the delete modal" do
    render
    expect(page).to have_content("_stubbed_delete_modal")
  end

  it "renders the back button" do
    render

    button = page.find(".collections-show__back-btn")
    expect(button.find("a")["href"]).to eq(collections_path)
  end

  it "renders the editable heading" do
    render

    expect(page).to have_content("_stubbed_editable_name_heading")
  end

  it "renders the photo count and date range label" do
    render

    expect(page).to have_content("_stubbed_photo_count")
  end

  it "renders the photo manager" do
    render

    # rubocop:disable LineLength
    props = {
      photoData: PhotoPresenter.wrap(@photos, view: view_context).map(&:photo_manager_props)
    }
    # rubocop:enable LineLength

    expect(page).to have_react_component("photo-manager").including_props(props)
  end

  context "no photos exist" do
    before do
      assign(:photos, [])
      assign(:photo_count, 0)
    end

    it "displays the empty state" do
      render

      expect(page.find(".collections-show__emtpy-state")).
        to have_content(t("#{@t_prefix}.empty"))

      expect(rendered).to have_content("_stubbed_photo_count")
      expect(rendered).
        to_not have_content(".collections-show__photo-manager-container")
    end
  end
end
