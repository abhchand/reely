require "rails_helper"

RSpec.feature "collections show page", type: :feature do
  let(:user) { create(:user) }
  let(:collection) { create_collection_with_photos(owner: user) }

  describe "editable name heading", :js do
    let(:textarea) { page.find(".collections-editable-name-heading__textarea") }

    before do
      log_in(user)
      visit collection_path(collection)

      # NOTE: `send_keys` adds characters at the beginning of the textarea
      # so the new name will be a prefix
      @original_name = collection.name
      @new_name = "new_" + @original_name
    end

    it "user can update collection name" do
      textarea.send_keys("new_")

      click_outside_textarea
      wait_for_ajax

      expect(textarea.value).to eq(@new_name)
      expect(collection.reload.name).to eq(@new_name)

      # Verify that the CSS is set to show the confirmation check mark
      # This only lasts for 1-2 seconds before disappearing, but should
      # still be within the window for Capybara to catch it
      expect(page).
        to have_selector(".collections-editable-name-heading__confirm.active")
    end

    it "user cannot enter a blank name" do
      fill_in("collection_name", with: "")
      expect(textarea.value).to eq("")

      click_outside_textarea
      wait_for_ajax

      expect(textarea.value).to eq(@original_name)
      expect(collection.reload.name).to eq(@original_name)
    end

    it "user can also confirm input via the :enter key" do
      textarea.send_keys("new_")

      textarea.send_keys(:enter)
      wait_for_ajax

      expect(textarea.value).to eq(@new_name)
      expect(collection.reload.name).to eq(@new_name)
    end

    it "user can cancel any input via the :escape key" do
      textarea.send_keys("new_")
      expect(textarea.value).to eq(@new_name)

      textarea.send_keys(:escape)
      wait_for_ajax

      expect(textarea.value).to eq(@original_name)
      expect(collection.reload.name).to eq(@original_name)
    end

    def click_outside_textarea
      # Pick an arbitrary element somewhere else on the page
      page.find(".collections-index__date-range").click
    end
  end

  describe "deleting collection", :js do
    before do
      log_in(user)
      visit collection_path(collection)
    end

    it "user can delete a collection" do
      click_delete_icon
      expect(page).to have_selector(".modal", visible: true)

      expect do
        click_delete_button
      end.to change { Collection.count }.by(-1)

      expect(page).to have_current_path(collections_path)
      expect { collection.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "user can cancel the deletion" do
      click_delete_icon
      expect(page).to have_selector(".modal", visible: true)

      expect do
        click_cancel_button
      end.to change { Collection.count }.by(0)

      expect(page).to have_current_path(collection_path(collection))
      expect(page).to have_selector(".modal", visible: false)
    end

    def click_delete_icon
      page.find(".collections-show__action-bar-item--delete").click
    end

    def click_delete_button
      page.find(".modal-content__button--submit").click
      wait_for_ajax
    end

    def click_cancel_button
      page.find(".modal-content__button--cancel").click
    end
  end
end
