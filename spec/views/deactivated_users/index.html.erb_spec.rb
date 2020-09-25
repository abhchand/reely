require 'rails_helper'

RSpec.describe 'deactivated_users/index.html.erb', type: :view do
  let(:user) { create(:user) }

  before do
    # stub_view_context
    @t_prefix = 'deactivated_users.index'
  end

  it 'renders the body' do
    render
    expect(page.find('.deactivated-user-index .body')).to have_content(
      t("#{@t_prefix}.body")
    )
  end

  it 'renders the log out link' do
    render
    expect(page.find('.deactivated-user-index .log-out')).to have_link(
      t("#{@t_prefix}.log_out", href: destroy_user_session_path)
    )
  end
end
