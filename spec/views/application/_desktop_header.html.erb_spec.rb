require 'rails_helper'

RSpec.describe 'application/_desktop_header.html.erb', type: :view do
  let(:user) { create(:user) }
  let(:user_presenter) { UserPresenter.new(user, view: view_context) }

  before do
    stub_view_context
    stub_current_user
  end

  it 'renders the profile' do
    render

    # Profile

    expect(page.find('.desktop-header__profile')).to have_content(
      user.first_name.downcase
    )

    # Profile Pic

    expect(page.find('.desktop-header__profile-pic > a')['href']).to eq(
      root_path
    )
    expect(page.find('.desktop-header__profile-pic img')['src']).to eq(
      user_presenter.avatar_path
    )
  end
end
