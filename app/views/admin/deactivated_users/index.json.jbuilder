json.current_page @search_service.page
json.total_pages @search_service.total_pages
json.total_items @search_service.total_users
json.items @users do |user|
  json.id user.synthetic_id
  json.(
    user,
    :first_name,
    :last_name,
    :email,
    :roles
  )
  json.avatar_path user.avatar_path(size: :thumb)
  json.last_sign_in_at user.last_sign_in_at
end
