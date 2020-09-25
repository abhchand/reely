require 'English'

class Git
  class Hooks
    class PreCommit
      RAILS_ROOT = File.expand_path('../../..', __dir__).freeze

      # Runs all scripts in the ./scripts sub-directory, returning the
      # exit status. Meant to be used with git hooks
      def self.run
        if `pwd`.strip != RAILS_ROOT
          puts "Please run from the rails root directory\nAborting."
          return 1
        end

        exitstatus = []

        Dir[File.expand_path('scripts/*', __dir__)].each do |script|
          system(
            # Run the script from the shell as they could be any
            # type (bash, ruby, etc..)
            ". #{script}"
          )

          exitstatus << $CHILD_STATUS.exitstatus
        end

        exitstatus.any?(&:positive?) ? 1 : 0
      end
    end
  end
end
