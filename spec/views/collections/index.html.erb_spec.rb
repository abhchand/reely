require "rails_helper"

RSpec.describe "collections/index.html.erb", type: :view do
  let(:user) { create(:user) }

  before do
    @collection1 = create_collection_with_photos(photo_count: 1)
    @collection2 = create_collection_with_photos(photo_count: 1)

    assign(:collections, [@collection1, @collection2])

    # rubocop:disable Metrics/LineLength
    stub_template "layouts/_action_notifications.html.erb" => "_stubbed_action_notifications"
    stub_template("collections/_card.html.erb" => "_stubbed_collections_card")
    # rubocop:enable Metrics/LineLength
  end

  it "renders the view" do
    render

    expect(rendered).to have_content("_stubbed_action_notifications")
  end

  it "renders the create link" do
    render

    form = page.find(".collections-index-create")
    expect(form["method"]).to eq("post")
    expect(form["action"]).to eq(collections_path)
  end

  it "renders each collection card" do
    render

    expect(page.text).to match(
      "_stubbed_collections_card[\n\s]+_stubbed_collections_card"
    )
  end
end
