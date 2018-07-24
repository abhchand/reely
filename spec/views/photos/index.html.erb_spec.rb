require "rails_helper"

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
    it "displays the photos" do
      render

      page.all(".photo-grid__aspect-ratio").each_with_index do |photo_el, i|
        photo = photos[i]
        url = photo.source.url(:medium)

        expect(photo_el["data-id"]).to eq(photo.synthetic_id)
        expect(
          photo_el.find(".photo-grid__grid-element")["style"]
        ).to eq("background-image:url(#{url});")
      end
    end

    it "displays the taken at label for each photo" do
      photo = photos[0]

      render

      label = l(photo.taken_at, format: :month_and_year)
      label_css = ".photo-grid__taken-at-label"
      photo_el =
        page.find(".photo-grid__aspect-ratio[data-id='#{photo.synthetic_id}']")

      expect(photo_el.find(label_css)).to have_content(label)
    end
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
