module Devise::AuthHelper
  def ensure_native_auth_enabled
    return if native_auth_enabled?

    flash[:error] = t("helpers.devise.auth_helper.error")
    redirect_to(root_path)
  end
end
