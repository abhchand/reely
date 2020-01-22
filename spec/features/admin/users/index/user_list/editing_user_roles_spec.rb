require "rails_helper"

RSpec.feature "Editing User Roles", type: :feature, js: true do
  let(:admin) { create(:user, :admin) }
  let!(:user) { create(:user) }

  before { log_in(admin) }

  it "admin can deactivate a user" do
    visit admin_users_path

    expect_filter_table_records_to_be([user, admin])

    expect(displayed_roles_for(user)).to match_array([])
    click_filter_table_edit_user_roles_for(user)

    # Ensure "Cancel" button works
    click_modal_close
    expect_modal_is_closed(async: true)
    expect(displayed_roles_for(user)).to match_array([])
    expect(user.reload.roles.pluck(:name)).to match_array([])

    click_filter_table_edit_user_roles_for(user)

    # Add roles
    toggle_role(:admin)
    toggle_role(:director)
    click_modal_submit
    expect_modal_is_closed(async: true)
    expect(displayed_roles_for(user)).to eq(%w[admin director])
    expect(user.reload.roles.pluck(:name)).to eq(%w[admin director])

    click_filter_table_edit_user_roles_for(user)

    # Remove roles
    toggle_role(:director)
    click_modal_submit
    expect_modal_is_closed(async: true)
    expect(displayed_roles_for(user)).to eq(%w[admin])
    expect(user.reload.roles.pluck(:name)).to eq(%w[admin])
  end

  context "there is an error in updating the user roles" do
    before do
      service = double("Admin::UserRoles::UpdateService")
      allow(Admin::UserRoles::UpdateService).to receive(:call) { service }

      allow(service).to receive(:success?) { false }
      allow(service).to receive(:status) { 400 }
      allow(service).to receive(:error) { "Some error to display" }
      allow(service).to receive(:log) { "Some error to display" }
    end

    it "admin can view error in modal" do
      visit admin_users_path

      click_filter_table_edit_user_roles_for(user)

      # Ensure error feedback works
      toggle_role(:admin)
      click_modal_submit
      expect(modal_error).to match(/Some error to display/)
    end
  end

  def displayed_roles_for(user)
    row = page.find(".admin-user-list__row[data-id='#{user.synthetic_id}']")
    row.all(".roles > span").map(&:text)
  end

  def toggle_role(role_name)
    page.find("#user_role_#{role_name}").click
  end
end
