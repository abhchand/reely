json.current_page @search_service.page
json.total_pages @search_service.total_pages
json.total_items @search_service.total_user_invitations
json.items @user_invitations do |user_invitation|
  json.id user_invitation.id
  json.email user_invitation.email
  json.invited_at user_invitation.created_at
end
