RSpec.configure do |config|
  config.include WebpackHelper

  config.before(:suite) do
    should_run_webpack =
      RSpec.world.
      registered_example_group_files.
      any? { |f| f =~ %r{spec\/(features|views)} }

    if should_run_webpack
      packs_dir = Rails.root.join("public", "packs-test")

      if packs_dir.exist?
        puts "Clearing #{packs_dir}..."
        FileUtils.rm_rf(Dir.glob(packs_dir.join("*")))
      end

      puts "Running webpack..."
      Dir.chdir(Rails.root) { system "yarn run test-build" }
    end
  end
end
