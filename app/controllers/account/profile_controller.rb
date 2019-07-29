class Account::ProfileController < ApplicationController
  layout "with_responsive_navigation"

  def index
    @user = current_user
  end
end
