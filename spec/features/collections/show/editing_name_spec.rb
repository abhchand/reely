require "rails_helper"

RSpec.feature "collections show page", :js, type: :feature do
  let(:user) { create(:user) }
  let(:collection) { create_collection_with_photos(owner: user) }

  let(:textarea) { page.find(".collections-editable-name-heading__textarea") }

  before do
    log_in(user)
    visit collection_path(collection)

    # NOTE: `send_keys` adds characters at the beginning of the textarea
    # so the new name will be a prefix
    @original_name = collection.name
    @new_name = @original_name + "_new"
  end

  it "user can update collection name" do
    textarea.send_keys("_new")

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
    textarea.send_keys("_new")

    textarea.send_keys(:enter)
    wait_for_ajax

    expect(textarea.value).to eq(@new_name)
    expect(collection.reload.name).to eq(@new_name)
  end

  it "user can cancel any input via the :escape key" do
    textarea.send_keys("_new")
    expect(textarea.value).to eq(@new_name)

    textarea.send_keys(:escape)
    wait_for_ajax

    expect(textarea.value).to eq(@original_name)
    expect(collection.reload.name).to eq(@original_name)
  end

  def click_outside_textarea
    # Pick an arbitrary element somewhere else on the page
    page.find(".collections-show__date-range").click
  end
end
