require 'rails_helper'

RSpec.describe 'collections/_card.html.erb', type: :view do
  let(:collection) { create_collection_with_photos(photo_count: 4) }

  before do
    stub_view_context
    @t_prefix = 'collections.card'
  end

  describe 'cover photos' do
    it 'renders 4 photos as a link' do
      render_partial

      photos = collection.cover_photos

      # All photos should be linked to the collection
      expect(page.find('.collections-card__cover-photos-link')['href']).to eq(
        collection_path(collection)
      )

      (0..3).each do |photo_idx|
        photo_el =
          page.find(".collections-card__cover-photo[data-id='#{photo_idx}']")
        photo = PhotoPresenter.new(photos[photo_idx], view: nil)

        expect(photo_el['style']).to have_content(
          photo.source_file_path(size: :tile)
        )
      end
    end

    describe 'photo orientation' do
      let(:collection) { create_collection_with_photos(photo_count: 3) }

      it 'displays the photo with correct orientation' do
        photos = collection.cover_photos

        photos[0].exif_data['orientation'] = 'Rotate 90 CW'
        photos[1].exif_data['orientation'] = 'Horizontal (normal)'
        photos[2].exif_data['orientation'] = nil
        photos.map(&:save!)

        render_partial

        expected_transforms = [
          /transform:\s?rotate\(90deg\)/,
          /transform:\s?rotate/,
          /transform:\s?rotate/
        ]

        (0..3).each do |photo_idx|
          photo_el =
            page.find(".collections-card__cover-photo[data-id='#{photo_idx}']")

          expect(photo_el['style']).to match(expected_transforms[photo_idx])
        end
      end
    end

    context 'collection has less than 4 photos' do
      let(:collection) { create_collection_with_photos(photo_count: 3) }

      it 'assigns the blank class in place of missing photos' do
        render_partial

        photo_el = page.find(".collections-card__cover-photo[data-id='3']")

        expect(photo_el['style']).to be_nil
        expect(photo_el['class']).to match(
          /collections-card__cover-photo--blank/
        )
      end
    end
  end

  describe 'card info' do
    it 'displays the collection name' do
      render_partial

      expect(page.find('.collections-card__name')).to have_link(
        collection.name,
        href: collection_path(collection)
      )
    end

    context 'collection name is too long' do
      before { collection.update!(name: 'a' * 50) }

      it 'truncates the name' do
        render_partial

        truncated_name = 'a' * 32 + '...'

        expect(page.find('.collections-card__name')).to have_link(
          truncated_name,
          href: collection_path(collection)
        )
      end
    end
  end

  describe 'card menu' do
    it 'renders the menu links' do
      render_partial

      menu = page.find('.collections-card__menu')

      delete_el = menu.find('.collections-card__menu-item--delete')
      expect(delete_el).to have_content(t("#{@t_prefix}.delete"))

      share_el = menu.find('.collections-card__menu-item--share')
      expect(share_el).to have_content(t("#{@t_prefix}.share"))
    end
  end

  def render_partial
    render(partial: 'collections/card', locals: { collection: collection })
  end
end
