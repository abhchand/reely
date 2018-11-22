require "rails_helper"

RSpec.describe "collections/index.html.erb", type: :view do
  let(:user) { create(:user) }

  before do
    @collection1 = create_collection_with_photos(photo_count: 1)
    @collection2 = create_collection_with_photos(photo_count: 1)

    assign(:collections, [@collection1, @collection2])

    stub_template("collections/_card.html.erb" => "_stubbed_collections_card")
  end

  it "renders the create link" do
    render

    link = page.find(".collections-index-create")
    expect(link["href"]).to eq(root_path)
  end

  it "renders each collection card" do
    render

    expect(page.text).to match(
      "_stubbed_collections_card[\n\s]+_stubbed_collections_card"
    )
  end
end
