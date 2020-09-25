require 'rails_helper'

RSpec.feature 'photo manager add to collection', type: :feature do
  let(:user) { create(:user) }

  let!(:photos) do
    create_list(:photo, 3, owner: user).each_with_index do |photo, i|
      photo.update!(taken_at: i.days.ago)
    end
  end

  before do
    @t_prefix = 'components.photo_manager.control_panel.add_to_collection'
  end

  it 'user can only add to collection after selecting a photo', :js do
    log_in(user)
    visit photos_path

    enable_selection_mode

    expect_add_to_collections_icon_to_not_be_visible
    click_photo(photos[0])
    expect_add_to_collections_icon_to_be_visible
    click_photo(photos[0])
    expect_add_to_collections_icon_to_not_be_visible
  end

  it 'user can search and filter collections to add to', :js do
    _c1 = create(:collection, owner: user, name: 'Tamil')
    c2 = create(:collection, owner: user, name: 'Kannada')
    c3 = create(:collection, owner: user, name: 'Hindi')

    log_in(user)
    visit photos_path

    enable_selection_mode
    click_photo(photos[0])

    within_add_to_collection do
      open_dropdown_menu

      # Match "Hindi" and "Kannada"
      fill_in 'search', with: 'n'
      expect(displayed_dropdown_option_ids).to eq(
        [c3.synthetic_id, c2.synthetic_id]
      )

      # Match "Kannada"
      fill_in 'search', with: 'nn'
      expect(displayed_dropdown_option_ids).to eq([c2.synthetic_id])

      # Empty State
      fill_in 'search', with: 'nnn'
      expect(find('.react-select-or-create .select-items')).to have_content(
        t("#{@t_prefix}.no_results")
      )
    end
  end

  it 'user can add photos to a new collection', :js do
    log_in(user)
    visit photos_path

    enable_selection_mode
    click_photo(photos[0])
    click_photo(photos[2])

    before_count = Collection.count

    within_add_to_collection do
      open_dropdown_menu
      fill_in 'search', with: 'Cool Collection'
      create_collection_button.click
    end

    wait_for { Collection.count == (before_count + 1) }

    wait_for { Collection.last.name == 'Cool Collection' }
    wait_for(10) { Collection.last.photos == [photos[0], photos[2]] }

    # Also verify the new collection is visually added to the dropdown

    enable_selection_mode
    click_photo(photos[0])

    within_add_to_collection do
      open_dropdown_menu
      page.all('.select-items')
      expect_option_for(Collection.last)
    end
  end

  it 'user can add photos to an exisiting collection', :js do
    collection = create(:collection, owner: user, name: 'Tamil')
    # Add one of the photos to the collection to also test that the photo
    # doesn't get re-added.
    create(:photo_collection, photo: photos[0], collection: collection)

    log_in(user)
    visit photos_path

    enable_selection_mode
    click_photo(photos[0])
    click_photo(photos[2])

    before_count = collection.photos.count

    within_add_to_collection do
      open_dropdown_menu
      find_option_for(collection).click
    end

    wait_for { collection.reload.photos.count == before_count + 1 }
    expect(collection.photos).to match_array([photos[0], photos[2]])
  end

  describe 'on other pages besides Photos#index' do
    let(:collection) { create(:collection, owner: user) }

    before do
      photos.each do |photo|
        PhotoCollection.create!(photo: photo, collection: collection)
      end
    end

    context 'on Collections#show' do
      it 'user can add photos to a new collection', :js do
        log_in(user)
        visit collection_path(collection)

        enable_selection_mode
        click_photo(photos[0])
        click_photo(photos[2])

        before_count = Collection.count

        within_add_to_collection do
          open_dropdown_menu
          fill_in 'search', with: 'Cool Collection'
          create_collection_button.click
        end

        wait_for do
          Collection.count == (before_count + 1) &&
            Collection.last.name == 'Cool Collection'
        end
      end

      it 'user can add photos to an exisiting collection', :js do
        other_collection = create(:collection, owner: user, name: 'Tamil')

        log_in(user)
        visit collection_path(collection)

        enable_selection_mode
        click_photo(photos[0])
        click_photo(photos[2])

        before_count = other_collection.photos.count

        within_add_to_collection do
          open_dropdown_menu
          find_option_for(other_collection).click
        end

        wait_for { other_collection.reload.photos.count == before_count + 2 }
      end
    end

    context 'on Collections::SharingConfigController#show' do
      it 'user can not add to collection', :js do
        log_in(user)
        visit collections_sharing_display_path(id: collection.share_id)

        enable_selection_mode
        click_photo(photos[0])

        expect_add_to_collections_icon_to_not_be_visible
      end
    end
  end

  def displayed_dropdown_option_ids
    [].tap do |ids|
      all('.react-select-or-create .select-items li').each do |li|
        ids << li['data-id']
      end
    end
  end
end
