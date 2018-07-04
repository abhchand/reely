module FeatureHelpers
  def wait_for_ajax
    if @javascript_enabled
      Timeout.timeout(Capybara.default_max_wait_time) do
        loop until finished_all_xhr_requests?
      end
    end
  end

  def finished_all_xhr_requests?
    page.evaluate_script("jQuery.active").tap { |result| return result.zero? }
  rescue Timeout::Error
  end
end
