RSpec.shared_examples "photo grid" do
  before do
    # A bit of a hack, but the invoking specs could define `@photos` or a
    # memo-ized helper `photos`
    @photos ||= photos
  end

  it "displays the photos" do
    render

    page.all(".photo-grid__photo-container").each_with_index do |photo_el, i|
      photo = PhotoPresenter.new(@photos[i], view: nil)
      path = photo.source_file_path(size: :medium)

      expect(photo_el["data-id"]).to eq(photo.synthetic_id)
      expect(
        photo_el.find(".photo-grid__photo")["style"]
      ).to eq("background-image:url(#{path})")
    end
  end

  it "displays the taken at label for each photo" do
    photo = @photos[0]

    render

    label = l(photo.taken_at, format: :month_and_year)
    label_css = ".photo-grid__taken-at-label"
    photo_el = find_photo_element(photo)

    expect(photo_el.find(label_css)).to have_content(label)
  end

  describe "photo orientation" do
    before do
      # Ensure at least 3 photos exist, if not create more
      additional = 3 - @photos.count
      additional.times { @photos << create(:photo) } if additional.positive?

      @photos[0].exif_data["orientation"] = "Rotate 90 CW"
      @photos[1].exif_data["orientation"] = "Horizontal (normal)"
      @photos[2].exif_data["orientation"] = nil
      @photos.map(&:save!)
    end

    it "displays the photo with correct orientation" do
      render

      style_for = proc do |idx|
        find_photo_element(@photos[idx]).
          find(".photo-grid__photo")["style"]
      end

      style = style_for.call(0)
      expect(style).to match(/transform:\s?rotate\(90deg\)/)

      style = style_for.call(1)
      expect(style).to_not match(/transform:\s?rotate/)

      style = style_for.call(2)
      expect(style).to_not match(/transform:\s?rotate/)
    end

    it "displays the overlay with correct orientation" do
      render

      style_for = proc do |idx|
        find_photo_element(@photos[idx]).
          find(".photo-grid__photo-overlay")["style"]
      end

      style = style_for.call(0)
      expect(style).to match(/transform:\s?rotate\(-90deg\)/)

      style = style_for.call(1)
      expect(style).to_not match(/transform:\s?rotate/)

      style = style_for.call(2)
      expect(style).to_not match(/transform:\s?rotate/)
    end
  end

  def find_photo_element(photo)
    page.find(".photo-grid__photo-container[data-id='#{photo.synthetic_id}']")
  end
end
