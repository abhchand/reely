class Git
  class Hooks
    class PreCommit
      RAILS_ROOT = File.expand_path("../../../..", __FILE__).freeze

      # Runs all scripts in the ./scripts sub-directory, returning the
      # exit status. Meant to be used with git hooks
      def self.run
        if `pwd`.strip != RAILS_ROOT
          puts "Please run from the rails root directory\nAborting."
          return 1
        end

        exitstatus = []

        Dir[File.expand_path("../scripts/*", __FILE__)].each do |script|
          # Run the script from the shell as they could be any
          # type (bash, ruby, etc..)
          system(". #{script}")

          exitstatus << $?.exitstatus
        end

        exitstatus.any?(&:positive?) ? 1 : 0
      end
    end
  end
end
