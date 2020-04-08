module Admin
  module Audit
    class UserDescriptionService < BaseDescriptionService
      AUDITABLE_TYPE = "User".freeze

      def description
        case
        when created_as_native?       then describe_created_as_native
        when created_as_omniauth?     then describe_created_as_omniauth
        when updated_to_deactivated?  then describe_updated_to_deactivated
        when updated_to_activated?    then describe_updated_to_activated
        when updated_to_add_role?     then describe_updated_to_add_role
        when updated_to_remove_role?  then describe_updated_to_remove_role
        else
          unknown_audit_type
        end
      end

      private

      def user
        subject
      end

      def created_as_native?
        create_action? && user.native?
      end

      def created_as_omniauth?
        create_action? && user.omniauth?
      end

      def updated_to_deactivated?
        update_action? &&
          modified?("deactivated_at") &&
          old_value_for("deactivated_at").blank? &&
          new_value_for("deactivated_at").present?
      end

      def updated_to_activated?
        update_action? &&
          modified?("deactivated_at") &&
          old_value_for("deactivated_at").present? &&
          new_value_for("deactivated_at").blank?
      end

      def updated_to_add_role?
        # We track changes to the role as an update to the user,
        # under a special attribute called `audited_roles`.
        # See `Admin::UserRoles::UpdateService`.
        update_action? &&
          modified?("audited_roles") &&
          old_value_for("audited_roles").blank? &&
          new_value_for("audited_roles").present?
      end

      def updated_to_remove_role?
        # We track changes to the role as an update to the user,
        # under a special attribute called `audited_roles`.
        # See `Admin::UserRoles::UpdateService`.
        update_action? &&
          modified?("audited_roles") &&
          old_value_for("audited_roles").present? &&
          new_value_for("audited_roles").blank?
      end

      def describe_created_as_native
        t(".created_as_native")
      end

      def describe_created_as_omniauth
        t(".created_as_omniauth", provider: user.provider)
      end

      def describe_updated_to_deactivated
        t(".updated_to_deactivated", email: user.email)
      end

      def describe_updated_to_activated
        t(".updated_to_activated", email: user.email)
      end

      def describe_updated_to_add_role
        t(
          ".updated_to_add_role",
          name: user.name,
          role: new_value_for("audited_roles")
        )
      end

      def describe_updated_to_remove_role
        t(
          ".updated_to_remove_role",
          name: user.name,
          role: old_value_for("audited_roles")
        )
      end
    end
  end
end
