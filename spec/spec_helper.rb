RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = false
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.example_status_persistence_file_path = "spec/examples.txt"
  config.disable_monkey_patching!
  config.default_formatter = "doc" if config.files_to_run.one?
  config.profile_examples = 10
  config.order = :random

  Kernel.srand config.seed

  config.before(:each, js: true) do
    # Since we (sometimes) use the same driver for both JS and non-JS tests
    # we need an easy way of distinguishing when JS is actually enabled.
    @javascript_enabled = true
  end

  #
  # Mobile
  #

  config.before(:each, :mobile, type: :feature) do
    # rack-test has no concept of a window so need to use
    # :selenium_chrome_headless for mobile responsive tests
    Capybara.current_driver = :selenium_chrome_headless

    resize_window_to_mobile
  end
end
