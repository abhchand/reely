require 'rails_helper'

RSpec.describe 'collections/_editable_name_heading.html.erb', type: :view do
  let(:collection) { create_collection_with_photos(photo_count: 0) }

  it 'renders the editable textarea' do
    render_partial

    textarea = page.find('.collections-editable-name-heading > textarea')
    expect(textarea['data-id']).to eq(collection.synthetic_id)
  end

  it 'renders the confirmation icon' do
    render_partial

    expect(page).to have_selector('.collections-editable-name-heading > svg')
  end

  def render_partial
    render(
      partial: 'collections/editable_name_heading',
      locals: { collection: collection }
    )
  end
end
