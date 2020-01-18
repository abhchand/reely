Capybara.register_driver :headless_chrome do |app|
  caps = Selenium::WebDriver::Remote::Capabilities.chrome(
    "goog:loggingPrefs" => {
      browser: "ALL",
      client: "ALL",
      driver: "ALL",
      server: "ALL"
    }
  )

  opts = Selenium::WebDriver::Chrome::Options.new
  chrome_args = %w[
    --headless
    --window-size=1440,800
    --no-sandbox
    --disable-dev-shm-usage
    --enable-logging
  ]
  chrome_args.each { |arg| opts.add_argument(arg) }

  Capybara::Selenium::Driver.new(
    app,
    browser: :chrome,
    options: opts,
    desired_capabilities: caps
  )
end
