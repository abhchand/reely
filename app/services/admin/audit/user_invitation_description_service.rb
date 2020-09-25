module Admin
  module Audit
    class UserInvitationDescriptionService < BaseDescriptionService
      AUDITABLE_TYPE = 'UserInvitation'.freeze

      def description
        case
        when created?
          describe_created
        when destroyed?
          describe_destroyed
        else
          unknown_audit_type
        end
      end

      private

      def user_invitation
        subject
      end

      def created?
        create_action?
      end

      def destroyed?
        destroy_action?
      end

      def describe_created
        t('.created', email: new_value_for('email'))
      end

      def describe_destroyed
        t('.destroyed', email: old_value_for('email'))
      end
    end
  end
end
