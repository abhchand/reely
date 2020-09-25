class RootController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[new]

  # The controller action mapped to `root_path`
  #
  # This serves as a dead-simple redirector based on whether the user is signed
  # in or not.
  #
  # Devise does provide this functionality with it's `authenticated` route
  # helper. In `config/routes`:
  #
  #     authenticated :user do
  #       root to: redirect("/photos"), as: :authenticated_root
  #     end
  #     root to: redirect("/users/log-in")
  #
  # This approach is inconvenient for two reasons:
  #
  #   1. It creates a separate `root_path` and `authenticated_root_path`
  #   2. It doesn't allow full control and customized logic.
  def new
    redirect_to(user_signed_in? ? photos_path : new_user_session_path)
  end
end
