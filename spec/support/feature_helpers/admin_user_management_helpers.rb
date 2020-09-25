module FeatureHelpers
  def click_users_tab
    page.find(".tabnav__tab button[data-id='0']").click
  end

  def click_user_invitations_tab
    page.find(".tabnav__tab button[data-id='1']").click
  end

  def click_deactivate_users_tab
    page.find(".tabnav__tab button[data-id='2']").click
  end

  def click_create_user_invitation_button
    page.find('.admin-user-invitation-list__create-user-invitation-btn').click
  end
end
