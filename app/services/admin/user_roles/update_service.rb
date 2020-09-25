class Admin::UserRoles::UpdateService
  include Interactor

  def call
    @current_user = context.current_user
    @user = context.user
    @roles = (context.roles || []).uniq
    @i18n_prefix = 'admin.user_roles.update_service'

    handle_invalid_roles unless roles_valid?
    update_roles!
  end

  private

  attr_reader :user

  def current_roles
    @current_roles ||= user.roles.map(&:name)
  end

  def new_roles
    @roles
  end

  def roles_valid?
    @roles.all? { |r| ALL_ROLES.include?(r) }
  end

  def update_roles!
    (new_roles - current_roles).each do |role|
      user.add_role(role, modifier: @current_user)
    end
    (current_roles - new_roles).each do |role|
      user.remove_role(role, modifier: @current_user)
    end
  end

  def handle_invalid_roles
    context.fail!(
      log: "#{log_tags} Invalid list of roles: #{@roles.join(', ')}}",
      error: I18n.t("#{@i18n_prefix}.invalid_roles"),
      status: 403
    )
  end

  def log_tags
    "[#{self.class.name}] [#{@job_id}]"
  end
end
