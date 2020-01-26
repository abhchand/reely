require "rails_helper"

RSpec.feature "Filter and Paginate", type: :feature, js: true do
  let(:admin) { create(:user, :admin) }
  let(:email) { "asha@singers.com" }

  before { @t_prefix = "admin.audit" }

  it "inviting a user is audited" do
    log_in(admin)

    # Invite another user
    visit admin_users_path
    click_user_invitations_tab
    click_create_user_invitation_button
    fill_in("user_invitation[email]", with: email)
    click_modal_submit
    expect_modal_is_closed(async: true)

    # Check if audited
    visit admin_audits_path
    expect(audit_table_displayed_descriptions[0]).to eq(
      t(
        "#{@t_prefix}.user_invitation_description.created",
        email: email
      )
    )
  end

  it "uninviting a user is audited" do
    log_in(admin)

    # Create existing invitation
    user_invitation = create(:user_invitation, email: email)

    # Uninvite user
    visit admin_users_path
    click_user_invitations_tab
    click_filter_table_delete_for(user_invitation)
    click_modal_submit
    expect_modal_is_closed(async: true)

    # Check if audited
    visit admin_audits_path
    expect(audit_table_displayed_descriptions[0]).to eq(
      t(
        "#{@t_prefix}.user_invitation_description.destroyed",
        email: email
      )
    )
  end

  it "creating an account with native auth is audited" do
    register(
      first_name: "Asha",
      last_name: "Bhosle",
      email: "asha@singers.com",
      password: "Best!s0ngz"
    )

    admin = User.last

    confirm(admin)
    log_in(admin, password: "Best!s0ngz")

    admin.add_role(:admin)

    # Check if audited
    # The most recent audits (index [0] and [1]) will be adding the `:admin`
    # role and confirming the email, so we check the next audit (index [2])
    visit admin_audits_path
    expect(audit_table_displayed_descriptions[2]).to eq(
      t("#{@t_prefix}.user_description.created_as_native")
    )
  end

  it "creating an account with OmniAuth auth is audited" do
    mock_google_oauth2_auth_response(
      uid: "some-fake-uid",
      info: {
        first_name: "Srinivasa",
        last_name: "Ramanujan",
        email: "srini@math.com",
        image: fixture_path_for("images/chennai.jpg")
      }
    )
    log_in_with_omniauth("google_oauth2")

    admin = User.last
    admin.add_role(:admin)

    # Check if audited
    # The most recent audit (index [0]) will be adding the `:admin` role
    # directly above, so we check the next audit (index [1])
    visit admin_audits_path
    expect(audit_table_displayed_descriptions[1]).to eq(
      t(
        "#{@t_prefix}.user_description.created_as_omniauth",
        provider: "google_oauth2"
      )
    )
  end

  it "deactivating an account is audited" do
    other_user = create(:user)

    log_in(admin)

    # Deactivate `other_user`
    visit admin_users_path
    click_filter_table_deactivate_for(other_user)
    click_modal_submit
    expect_modal_is_closed(async: true)

    # Check if audited
    visit admin_audits_path
    expect(audit_table_displayed_descriptions[0]).to eq(
      t(
        "#{@t_prefix}.user_description.updated_to_deactivated",
        email: other_user.email
      )
    )
  end

  it "editing roles is audited" do
    other_user = create(:user)

    log_in(admin)

    # Add director role to other user
    visit admin_users_path
    click_filter_table_edit_user_roles_for(other_user)
    page.find("#user_role_director").click # Check box for `director`
    click_modal_submit
    expect_modal_is_closed(async: true)

    # Remove director role from other user
    visit admin_users_path
    click_filter_table_edit_user_roles_for(other_user)
    page.find("#user_role_director").click # Uncheck box for `director`
    click_modal_submit
    expect_modal_is_closed(async: true)

    # Check if audited
    visit admin_audits_path
    expect(audit_table_displayed_descriptions[0]).to eq(
      t(
        "#{@t_prefix}.user_description.updated_to_remove_role",
        name: other_user.name,
        role: "director"
      )
    )
    expect(audit_table_displayed_descriptions[1]).to eq(
      t(
        "#{@t_prefix}.user_description.updated_to_add_role",
        name: other_user.name,
        role: "director"
      )
    )
  end
end
