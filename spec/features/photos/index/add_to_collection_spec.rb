require "rails_helper"

RSpec.feature "photos carousel", type: :feature do
  let(:user) { create(:user) }

  let!(:photos) do
    create_list(:photo, 3, owner: user).each_with_index do |photo, i|
      photo.update!(taken_at: i.days.ago)
    end
  end

  before do
    @t_prefix =
      "components.photo_grid.control_panel.bulk_action_panel.add_to_collection"
  end

  it "user can search and filter collections to add to", :js do
    _c1 = create(:collection, owner: user, name: "Tamil")
    c2 = create(:collection, owner: user, name: "Kannada")
    c3 = create(:collection, owner: user, name: "Hindi")

    log_in(user)
    visit photos_path

    enable_selection_mode

    within_add_to_collection do
      open_dropdown_menu

      # Match "Hindi" and "Kannada"
      fill_in "search", with: "n"
      expect(displayed_dropdown_option_ids).
        to eq([c3.synthetic_id, c2.synthetic_id])

      # Match "Kannada"
      fill_in "search", with: "nn"
      expect(displayed_dropdown_option_ids).
        to eq([c2.synthetic_id])

      # Empty State
      fill_in "search", with: "nnn"
      expect(find(".creatable-select-dropdown-select-options")).
        to have_content(t("#{@t_prefix}.empty_state"))
    end
  end

  it "user can add photos to a new collection", :js do
    log_in(user)
    visit photos_path

    enable_selection_mode
    click_photo(photos[0])
    click_photo(photos[2])

    within_add_to_collection do
      open_dropdown_menu

      expect do
        fill_in "search", with: "Cool Collection"
        create_collection.click
        wait_for_ajax
      end.to change { Collection.count }.by(1)
    end

    collection = Collection.last
    expect(collection.name).to eq("Cool Collection")
    expect(collection.photos).to match_array([photos[0], photos[2]])
  end

  it "user can add photos to an exisiting collection", :js do
    collection = create(:collection, owner: user, name: "Tamil")
    # Add one of the photos to the collection to also test that the photo
    # doesn't get re-added.
    create(:photo_collection, photo: photos[0], collection: collection)

    log_in(user)
    visit photos_path

    enable_selection_mode
    click_photo(photos[0])
    click_photo(photos[2])

    within_add_to_collection do
      open_dropdown_menu

      expect do
        find_option_for(collection).click
        wait_for_ajax
      end.to change { collection.reload.photos.count }.by(1)
    end

    expect(collection.photos).to match_array([photos[0], photos[2]])
  end

  describe "keyboard navigation" do
    it "user can add photos to a new collection", :js do
      log_in(user)
      visit photos_path

      enable_selection_mode
      click_photo(photos[0])
      click_photo(photos[2])

      within_add_to_collection do
        open_dropdown_menu

        expect do
          fill_in "search", with: "Cool Collection"
          create_collection.send_keys(:enter)

          wait_for_ajax
        end.to change { Collection.count }.by(1)
      end

      collection = Collection.last
      expect(collection.name).to eq("Cool Collection")
      expect(collection.photos).to match_array([photos[0], photos[2]])
    end

    it "user can add photos to an exisiting collection", :js do
      c1 = create(:collection, owner: user, name: "Tamil")
      _c2 = create(:collection, owner: user, name: "Kannada")

      log_in(user)
      visit photos_path

      enable_selection_mode
      click_photo(photos[0])
      click_photo(photos[2])

      within_add_to_collection do
        open_dropdown_menu

        expect do
          # Also test in passing that the arrow keys navigate the options
          # Collections are reverse order: c2, c1
          search_input.send_keys(:arrow_down)
          expect(selected_option_id).to eq(c1.synthetic_id)

          search_input.send_keys(:enter)
          wait_for_ajax
        end.to change { c1.reload.photos.count }.by(2)
      end

      expect(c1.photos).to match_array([photos[0], photos[2]])
    end
  end

  # rubocop:disable Lint/UnusedMethodArgument
  def within_add_to_collection(&block)
    within(".photo-grid-bulk-action-panel__item--add-to-collection") do
      yield
    end
  end
  # rubocop:enable Lint/UnusedMethodArgument

  def open_dropdown_menu
    find(".creatable-select-dropdown__open-menu-button").click
  end

  def find_option_for(collection)
    id = collection.synthetic_id
    # The <div> has the click event
    find(".creatable-select-dropdown-select-options li[data-id='#{id}'] div")
  end

  def search_input
    find(".creatable-select-dropdown-search-input input")
  end

  def create_collection
    find(".creatable-select-dropdown-create-option")
  end

  def selected_option_id
    find(".creatable-select-dropdown-select-options li.selected")["data-id"]
  end

  def displayed_dropdown_option_ids
    [].tap do |ids|
      all(".creatable-select-dropdown-select-options li").each do |li|
        ids << li["data-id"]
      end
    end
  end
end
