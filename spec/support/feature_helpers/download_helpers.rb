module FeatureHelpers
  BROWSER_DOWNLOAD_PATH = Rails.root.join("tmp/browser-downloads")

  def browser_downloads
    Dir[BROWSER_DOWNLOAD_PATH.join("*")]
  end

  def browser_download
    browser_downloads.first
  end

  def browser_download_content
    wait_for_download
    File.read(browser_download)
  end

  def wait_for_browser_download
    Timeout.timeout(30) do
      sleep 0.1 until browser_downloaded?
    end
  end

  def browser_downloaded?
    !browser_downloading? && browser_downloads.any?
  end

  def browser_downloading?
    browser_downloads.grep(/\.crdownload$/).any?
  end

  def clear_browser_downloads
    reset_dir!(browser_downloads)
  end
end
