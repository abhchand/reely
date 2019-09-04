require "open-uri"

module UserManagement
  module Omniauth
    class GoogleOauth2Service
      include Interactor

      after { context.user = user }

      def call
        @job_id = SecureRandom.hex
        @auth = context.auth

        handle_blank_auth if @auth.blank?
        handle_blank_uid if uid.blank?

        return if user.persisted?

        handle_failed_creation unless create_user
        handle_failed_avatar_attachment unless attach_avatar
      end

      private

      def user
        @user ||=
          User.find_or_initialize_by(provider: "google_oauth2", uid: uid)
      end

      def uid
        @auth&.uid
      end

      def first_name
        @auth.dig(:info, :first_name)
      end

      def last_name
        @auth.dig(:info, :last_name)
      end

      def email
        @auth.dig(:info, :email)
      end

      def avatar_url
        @auth.dig(:info, :image)
      end

      def create_user
        user.attributes = {
          first_name: first_name,
          last_name: last_name,
          email: email
        }

        user.save
      end

      def attach_avatar
        return true if avatar_url.blank?

        # rubocop:disable Security/Open
        file = open(avatar_url)
        # rubocop:enable Security/Open
        user.avatar.attach(io: file, filename: SecureRandom.hex)
        true
      rescue StandardError => e
        @avatar_error = e
        false
      end

      def handle_blank_uid
        context.fail!(
          log: "#{log_tags} Missing uid",
          error: I18n.t("generic_error")
        )
      end

      def handle_blank_auth
        context.fail!(
          log: "#{log_tags} Missing auth",
          error: I18n.t("generic_error")
        )
      end

      def handle_failed_creation
        context.fail!(
          log: "#{log_tags} User validation errors: #{user.errors.messages}",
          error: I18n.t("generic_error")
        )
      end

      def handle_failed_avatar_attachment
        context.log =
          "#{log_tags} Failed avatar attachment: #{@avatar_error.message}"
      end

      def log_tags
        "[#{self.class.name}] [#{@job_id}]"
      end
    end
  end
end
