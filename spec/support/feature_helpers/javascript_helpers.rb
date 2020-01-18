module FeatureHelpers
  def console_logs
    page.driver.browser.manage.logs.get(:browser)
  end
end
