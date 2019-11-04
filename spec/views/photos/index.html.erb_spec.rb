require "rails_helper"

RSpec.describe "photos/index.html.erb", type: :view do
  let(:user) { create(:user) }
  let(:photos) { create_list(:photo, 2) }
  let(:collections) { create_list(:collection, 1, owner: user) }

  before do
    stub_view_context

    # rubocop:disable LineLength
    stub_template "layouts/_action_notifications.html.erb" => "_stubbed_action_notifications"
    stub_template "layouts/_flash.html.erb" => "_stubbed_flash"
    stub_template "shared/_photo_count.html.erb" => "_stubbed_photo_count"
    # rubocop:enable LineLength

    assign(:photos, photos)
    assign(:photo_count, photos.count)
    assign(:collections, collections)

    @t_prefix = "photos.index"
  end

  it "renders the action notifications" do
    render
    expect(rendered).to have_content("_stubbed_action_notifications")
  end

  it "renders the flash" do
    render
    expect(rendered).to have_content("_stubbed_flash")
  end

  it "renders the photo count" do
    render
    expect(rendered).to have_content("_stubbed_photo_count")
  end

  it "renders the photo grid" do
    render

    # rubocop:disable LineLength
    props = {
      photoData: PhotoPresenter.wrap(photos, view: view_context).map(&:photo_grid_props),
      collections: CollectionPresenter.wrap(collections, view: view_context).map(&:photo_grid_props)
    }
    # rubocop:enable LineLength

    expect(page).to have_react_component("photo-grid").including_props(props)
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
