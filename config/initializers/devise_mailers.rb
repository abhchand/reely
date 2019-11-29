module Devise
  module Mailers
    module Helpers
      # rubocop:disable Metrics/LineLength

      # Devise creates scoped mailers under: app/views/users/mailer/*
      # Ideally it should live under:        app/views/mailers/devise_mailer/users/*
      #
      # The latter is so that we can have everything organized in one place,
      # along with specs and previews. It also conforms to the key namespace
      # use by ActionMailer to look up translations.
      #
      # Devise uses two helper methods that need to be overriden here to
      # correct the above:
      #
      #   1. `template_paths` - returns a list of paths to search for the
      #      template. This is used directly as an argument to `mail`'s
      #      `template_path` option:
      #
      #   2. `subject_for` - returns an email subject translation based on
      #      a prefixed translation lookup path / scope
      #
      # See: https://github.com/plataformatec/devise/blob/master/lib/devise/mailers/helpers.rb#L64
      #
      # Also see app/mailers/base_sendgrid_mailer.rb which defines similar
      # template paths for non-Devise mailers.
      #

      def template_paths
        template_path = _prefixes.dup
        template_path.unshift "mailers/devise_mailer/#{@devise_mapping.scoped_path}" if self.class.scoped_views?
        template_path
      end

      def subject_for(key)
        I18n.t(
          :subject,
          scope: [:devise_mailer, devise_mapping.scoped_path.to_sym, key]
        )
      end
      # rubocop:enable Metrics/LineLength
    end
  end
end
