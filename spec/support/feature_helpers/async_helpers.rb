module FeatureHelpers
  # rubocop:disable Lint/UnusedMethodArgument
  def wait_for(timeout = Capybara.default_max_wait_time, &block)
    return unless block_given?

    Timeout.timeout(timeout) do
      loop until yield
    end
  end
  # rubocop:enable Lint/UnusedMethodArgument

  def wait_for_ajax
    return unless @javascript_enabled

    Timeout.timeout(Capybara.default_max_wait_time) do
      loop until finished_all_xhr_requests?
    end
  end

  def finished_all_xhr_requests?
    page.evaluate_script("jQuery.active").tap { |result| return result.zero? }
  rescue Timeout::Error # rubocop:disable Lint/HandleExceptions
  end
end
