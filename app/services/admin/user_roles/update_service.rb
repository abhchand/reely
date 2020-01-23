class Admin::UserRoles::UpdateService
  include Interactor

  def call
    @current_user = context.current_user
    @user = context.user
    @roles = (context.roles || []).uniq
    @i18n_prefix = "admin.user_roles.update_service"

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
      user.add_role(role)
      audit_role(role, "create")
    end
    (current_roles - new_roles).each do |role|
      user.remove_role(role)
      audit_role(role, "destroy")
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

  def audit_role(role, action)
    # Adding and removing roles represent creating and deleting `users_roles`
    # records. There's 2 difficulties in auditing this with the `audited` gem
    # No `UserRole` model exists. It's a table managed by `rolify`, so we have
    # to create our own audit record manually and track it as a "change" on
    # the User model.

    audited_changes =
      case action
      when "create"   then { "audited_roles" => [nil, role] }
      when "destroy"  then { "audited_roles" => [role, nil] }
      end

    max_audit_version =
      Audited::Audit.auditable_finder(
        @user.id,
        @user.class.name
      ).maximum(:version) || 0

    Audited::Audit.create(
      auditable: @user,
      user: @current_user,
      action: "update",
      audited_changes: audited_changes,
      version: max_audit_version + 1,
      request_uuid: ::Audited.store[:current_request_uuid] || SecureRandom.uuid,
      remote_address: ::Audited.store[:current_remote_address]
    )
  end
end
