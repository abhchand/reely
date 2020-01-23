module HasAuditableRoles
  extend ActiveSupport::Concern

  # The audit functionality works using ActiveRecord extensions and callbacks,
  # but user roles are managed by the `rolify` gem which doesn't provide
  # an ActiveRecord model for the joining table.
  #
  # The next best thing is to override the `add_role` and `remove_role` methods
  # so that they call the original and then manually create an Audit record.
  #
  # # Notes
  #
  # * The Audit record will reflect an update to the current model since the
  #   joining table has no model that can be referenced.
  #
  # * This approach also queries the joining table twice to get a before/after
  #   count. This isn't ideal but this isn't an action that's performed
  #   frequently enough to worry about it

  def add_role(role, opts = {})
    old_count = count_roles

    super(role).tap do
      audit_role(role, :add_role, opts[:modifier]) if count_roles > old_count
    end
  end

  def remove_role(role, opts = {})
    old_count = count_roles

    super(role).tap do
      audit_role(role, :remove_role, opts[:modifier]) if count_roles < old_count
    end
  end

  private

  def audit_role(role, action, modifier)
    Audited::Audit.create(
      auditable: self,
      user: modifier,
      action: "update",
      audited_changes: audited_changes_for(role, action),
      version: max_audit_version + 1,
      request_uuid: ::Audited.store[:current_request_uuid] || SecureRandom.uuid,
      remote_address: ::Audited.store[:current_remote_address]
    )
  end

  def count_roles
    self.class.connection.query(
      <<-SQL
      SELECT COUNT(*)
      FROM users_roles
      WHERE user_id = #{self[:id]}
      SQL
    )[0][0]
  end

  def max_audit_version
    Audited::Audit.auditable_finder(
      self[:id],
      self.class.name
    ).maximum(:version) || 0
  end

  def audited_changes_for(role, action)
    case action
    when :add_role    then { "audited_roles" => [nil, role] }
    when :remove_role then { "audited_roles" => [role, nil] }
    end
  end
end
