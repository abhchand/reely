module FeatureHelpers
  def resize_window_to_mobile
    resize_window_to(width: 400, height: 730)
  end

  def resize_window_to_tablet
    resize_window_to(width: 768, height: 1024)
  end

  def resize_window_to_desktop
    resize_window_to(width: 1440, height: 800)
  end

  def resize_window_default
    resize_window_to_desktop
  end

  def current_window_size
    Capybara.current_session.windows[0].size
  end

  private

  def resize_window_to(size)
    Capybara.current_session.windows[0].resize_to(size[:width], size[:height])
  end
end
