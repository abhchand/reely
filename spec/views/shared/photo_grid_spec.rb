RSpec.shared_examples "photo grid" do
  before do
    # A bit of a hack, but the invoking specs could define `@photos` or a
    # memo-ized helper `photos`
    @photos ||= photos
  end

  it "displays the photos" do
    render

    page.all(".photo-grid__aspect-ratio").each_with_index do |photo_el, i|
      photo = @photos[i]
      url = photo.source.url(:medium)

      expect(photo_el["data-id"]).to eq(photo.synthetic_id)
      expect(
        photo_el.find(".photo-grid__grid-element")["style"]
      ).to eq("background-image:url(#{url});")
    end
  end

  it "displays the taken at label for each photo" do
    photo = @photos[0]

    render

    label = l(photo.taken_at, format: :month_and_year)
    label_css = ".photo-grid__taken-at-label"
    photo_el =
      page.find(".photo-grid__aspect-ratio[data-id='#{photo.synthetic_id}']")

    expect(photo_el.find(label_css)).to have_content(label)
  end
end
