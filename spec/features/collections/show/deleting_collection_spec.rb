require "rails_helper"

RSpec.feature "deleting collection", :js, type: :feature do
  let(:user) { create(:user) }
  let(:collection) { create_collection_with_photos(owner: user) }

  before do
    log_in(user)
    visit collection_path(collection)
  end

  it "user can delete a collection" do
    click_delete_icon
    expect_modal_is_open

    old_count = Collection.count

    click_modal_submit
    wait_for { Collection.count == old_count - 1 }

    expect(page).to have_current_path(collections_path)
    expect { collection.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "user can cancel the deletion" do
    click_delete_icon
    expect_modal_is_open

    expect do
      click_modal_close
    end.to change { Collection.count }.by(0)

    expect(page).to have_current_path(collection_path(collection))
    expect_modal_is_closed
  end

  context "collection name was updated" do
    let(:textarea) do
      page.find(".collections-editable-name-heading__textarea")
    end

    before do
      @old_name = collection.name
      @new_name = @old_name + "_new"

      textarea.send_keys("_new")

      click_outside_textarea
      wait_for_ajax
    end

    it "delete modal heading reflects the updated collection name" do
      # Verify name was changed
      expect(textarea.value).to eq(@new_name)
      expect(collection.reload.name).to eq(@new_name)

      click_delete_icon

      heading = page.find(".modal-content__heading")
      expect(heading).to have_content(
        strip_tags(
          t("components.delete_collection.heading", collection_name: @new_name)
        )
      )

      old_count = Collection.count

      click_modal_submit
      wait_for { Collection.count == old_count - 1 }

      expect(page).to have_current_path(collections_path)
      expect do
        collection.reload
      end.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  def click_outside_textarea
    # Pick an arbitrary element somewhere else on the page
    page.find(".collections-show__date-range").click
  end

  def click_delete_icon
    page.find(".icon-tray__item--delete-collection button").click
  end
end
