require 'rails_helper'

RSpec.describe 'collections/show.html.erb', type: :view do
  let(:user) { create(:user) }

  before do
    @collection = create_collection_with_photos(photo_count: 2)
    @collections = [create(:collection, owner: user), @collection]
    @photos = @collection.photos
    @photo_count = 2
    @date_range_label = 'date range label'

    assign(:collection, @collection)
    assign(:collections, @collections)
    assign(:photos, @photos)
    assign(:photo_count, @photo_count)
    assign(:date_range_label, @date_range_label)

    stub_view_context

    # rubocop:disable Metrics/LineLength
    stub_template 'layouts/_action_notifications.html.erb' =>
                    '_stubbed_action_notifications'
    stub_template(
      '_editable_name_heading.html.erb' => '_stubbed_editable_name_heading'
    )
    stub_template('shared/_photo_count.html.erb' => '_stubbed_photo_count')
    # rubocop:enable Metrics/LineLength

    @t_prefix = 'collections.show'
  end

  it 'renders the action notifications' do
    render
    expect(rendered).to have_content('_stubbed_action_notifications')
  end

  it 'renders the editable heading' do
    render

    expect(page).to have_content('_stubbed_editable_name_heading')
  end

  it 'renders the photo count and date range label' do
    render

    expect(page).to have_content('_stubbed_photo_count')
    expect(page.find('.collections-show__date-range')).to have_content(
      @date_range_label
    )
  end

  it 'renders the photo manager' do
    render

    # rubocop:disable Metrics/LineLength
    props = {
      photos:
        PhotoPresenter.wrap(@photos, view: view_context).map(
          &:photo_manager_props
        ),
      currentCollection:
        CollectionPresenter.new(@collection, view: view_context)
          .photo_manager_props,
      collections:
        CollectionPresenter.wrap(@collections, view: view_context).map(
          &:photo_manager_props
        ),
      permissions: {
        allowAddingToCollection: true,
        allowDeletingCollection: true,
        allowDownloadingCollection: true,
        allowRemovingFromCollection: true,
        allowSharingCollection: true,
        isEditable: true
      }
    }
    # rubocop:enable Metrics/LineLength

    expect(page).to have_react_component('photo-manager').including_props(props)
  end

  context 'no photos exist' do
    before do
      assign(:photos, [])
      assign(:photo_count, 0)
    end

    it 'displays the empty state' do
      render

      expect(page.find('.collections-show__emtpy-state')).to have_content(
        t("#{@t_prefix}.empty")
      )

      expect(rendered).to have_content('_stubbed_photo_count')
      expect(rendered).to_not have_content(
                                '.collections-show__photo-manager-container'
                              )
    end
  end

  context 'no date range label is set' do
    before { assign(:date_range_label, nil) }

    it 'does not render the date range label' do
      expect(page).to_not have_selector('.collections-show__date-range')
    end
  end
end
