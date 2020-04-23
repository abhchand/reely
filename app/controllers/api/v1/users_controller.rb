class Api::V1::UsersController < Api::BaseController
  before_action :user, only: %i[update]

  def index
    authorize! :read, :users

    users = fetch_users
    users = search(users)
    users = paginate(users)
    users = UserPresenter.wrap(users, view: view_context)

    json = serialize(users, links: pagination_links(users))

    render json: json, status: :ok
  end

  def update
    authorize! :write, user

    user.attributes = update_params

    if user.save
      json = serialize(user)
      status = :ok
    else
      json = @user.serialize_errors
      status = :forbidden
    end

    render json: json, status: status
  end

  private

  def update_params
    params.require(:user).permit(
      :first_name,
      :last_name
    )
  end

  def fetch_users
    active = params[:active].present? ? to_bool(params[:active]) : true

    User.
      send(active ? :active : :deactivated).
      order("lower(first_name), lower(last_name), lower(email)")
  end

  def search(users)
    # FYI: Search logic will sanitize any input SQL in `params[:search]`
    Users::SearchService.perform(users, params[:search])
  end

  def serialize(user, opts = {})
    UserSerializer.new(
      user,
      { params: {} }.deep_merge(opts)
    ).serializable_hash
  end
end
