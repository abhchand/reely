require 'rails_helper'

RSpec.describe 'photos/new.html.erb', type: :view do
  before { @t_prefix = 'photos.new' }

  it 'renders the heading' do
    render
    expect(page.find('.page-heading')).to have_content(
      t("#{@t_prefix}.heading").downcase
    )
  end

  it 'renders the file uploader' do
    render

    props = {
      url: photos_path(format: :json),
      modelName: 'photo',
      attrName: 'source_file',
      maxFileCount: PhotosController::MAX_FILE_UPLOAD_COUNT,
      maxFileSize: Photos::ImportService::MAX_FILE_SIZE
    }

    expect(page).to have_react_component('file-uploader').including_props(props)
  end
end
